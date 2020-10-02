#ifndef __STRUCTURES_H__
#define __STRUCTURES_H__

#include <any>
#include <string>
#include <vector>
#include <cstdint>
#include <iostream>
#include <functional>
#include <unordered_map>
#include <sstream>

#define RUN_ALL_TESTS() RUN(suites, TestCase::requirements)

typedef int64_t s64;
typedef uint64_t u64; 
typedef int32_t s32;
typedef uint32_t u32;
typedef int16_t s16;
typedef uint16_t u16;
typedef uint8_t s8;
typedef int8_t u8;
typedef float f32;
typedef double f64;
typedef long double f80;

namespace utf {

template<typename T>
struct Assertion {
	std::string m_errorMessage;
    std::string m_operand;
    T m_firstOperand;
    T m_secondOperand;
    bool m_check;
};

template<typename T>
struct Holder {
    std::vector<Assertion<T>> m_assertions;
};

template<typename T>
struct Test {
    std::string m_suiteName;
    std::string m_testName;
    void (*m_functionTester)(Holder<T> *);
};

template<typename T>
struct Insertion {
    Insertion(const std::string& suite_name, const std::string& test_name, void(*function_to_test)(Holder<T> *), std::unordered_map<std::string, std::vector<Test<T>>> &suites) {
        suites[suite_name].push_back(Test<T>{ suite_name, test_name, function_to_test });
    }
    virtual ~Insertion() = default;
};

struct any : public std::any {
    std::function<void(std::ostream&, const std::any&, char delim)> print;

    template <typename T>
    any(const T& t) : std::any(t) {
        this->print = [](std::ostream& os, const std::any& a, char delim) { 
    		os << std::any_cast<const T&>(a) << delim;
 	    };
    }
};

template<typename, typename = void>
constexpr bool is_complete_type_v = false;

template<typename T>
constexpr bool is_complete_type_v<T, std::void_t<decltype(sizeof(T))>> = true;
    
template<typename T, typename Callable>
void call_if_defined(Callable&& callable) {
  if constexpr (is_complete_type_v<T>) {
    callable(static_cast<T*>(nullptr));
  }
}

template <typename... Args>
struct ambiguate : public Args... {};

template<typename A, typename = void>
struct got_type : std::false_type {};

template<typename A>
struct got_type<A> : std::true_type {
    typedef A type;
};

template<typename T, T>
struct sig_check : std::true_type {};

template<typename Alias, typename AmbiguitySeed>
struct has_member {
    template<typename C> static char ((&f(decltype(&C::value))))[1];
    template<typename C> static char ((&f(...)))[2];

    static_assert((sizeof(f<AmbiguitySeed>(0)) == 1), "Check member names, it should be identical!");

    static bool const value = sizeof(f<Alias>(0)) == 2;
};

std::string to_string(std::string str) {
    return std::move(str);
}

template <typename T>
std::enable_if_t<!std::is_convertible<T, std::string>::value, std::string> to_string(T&& value) {
    using std::to_string;
    return std::to_string(std::forward<T>(value));
}

}

#endif

