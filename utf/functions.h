#ifndef __FUNCTIONS_H__
#define __FUNCTIONS_H__

#include "structures.h"

static std::unordered_map<std::string, std::vector<utf::Test<utf::any>>> suites;

#define TEST(suite_name, test_name)                                                                                                                                             \
    template<typename T>                                                                                                                                                        \
    constexpr void __##suite_name##__##test_name(utf::Holder<T> *holder);                                                                                                       \
    utf::Insertion<utf::any> ut__##suite_name##__##test_name{  #suite_name, #test_name, __##suite_name##__##test_name, suites };                                                \
    template<typename T>                                                                                                                                                        \
    constexpr void __##suite_name##__##test_name(utf::Holder<T> *holder)

#define ASSERT_EQUAL(first_operand, second_operand, message)                                                                                                                    \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "==", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })

#define ASSERT_NOT_EQUAL(first_operand, second_operand, message)                                                                                                                \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "!=", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })

#define ASSERT_GREATER(first_operand, second_operand, message)                                                                                                                  \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", ">", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })

#define ASSERT_LESS(first_operand, second_operand, message)                                                                                                                     \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "<", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })

#define ASSERT_GREATER_OR_EQUAL(first_operand, second_operand, message)                                                                                                         \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", ">=", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })

#define ASSERT_LESS_OR_EQUAL(first_operand, second_operand, message)                                                                                                            \
    holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "<=", T(first_operand), T(second_operand), utf::stringify(first_operand) == utf::stringify(second_operand) })
    
#define ASSERT_FUNCTION(function_name, message)                                                                                                                                 \
	if (!function_name) {                                                                                                                                                       \
		holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0, false });                                                                      \
	}                                                                                                                                                                           \
	if (function_name)                                                                                                                       
	
#define ASSERT_FUNCTION_SIGNATURE(function_name, signature, message)                                                                                                            \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
													  CHECK_FUNC_SIGNATURE(function_name, signature) == true });                                                                \
	if (true)             
	
#define ASSERT_CLASS_CONSTRUCTOR(message, class_name, ...)                                                                                                                      \
	ASSERT_CALL_CLASS(class_name)                                                                                                                                               \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
								   std::is_constructible<class_name, ##__VA_ARGS__>::value == 1 });                                                                             \
	if constexpr (std::is_constructible<class_name, ##__VA_ARGS__>::value)

#define ASSERT_CLASS_METHOD(class_name, method_name, message)                                                                                                                   \
	ASSERT_CALL_CLASS(class_name)                                                                                                                                               \
	const bool __class_##class_name##_has_method_##method_name##__ = __has_method_##method_name##__<class_name>::value;                                                         \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
								   __class_##class_name##_has_method_##method_name##__ == true });                                                                              \
	if constexpr (__class_##class_name##_has_method_##method_name##__)
	
#define ASSERT_CLASS_ATTRIBUTE(class_name, attribute_name, message)                                                                                                             \
	ASSERT_CALL_CLASS(class_name)                                                                                                                                               \
	const bool __class_##class_name##_has_attribute_##attribute_name##__ = __has_attribute_##attribute_name##__<class_name>::value;                                             \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
								   __class_##class_name##_has_attribute_##attribute_name##__ == true });                                                                        \
	if constexpr (__class_##class_name##_has_attribute_##attribute_name##__)
	
#define ASSERT_CLASS_METHOD_SIGNATURE(class_name, method_name, template_postfix, message)                                                                                       \
	ASSERT_CALL_CLASS(class_name)                                                                                                                                               \
	const bool __class_##class_name##_has_method_##method_name##_with_##template_postfix##__ = __has_method_with_sig_##template_postfix##__<class_name>::value;                 \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
			 __class_##class_name##_has_method_##method_name##_with_##template_postfix##__ == true });                                                                          \
	if constexpr (__class_##class_name##_has_method_##method_name##_with_##template_postfix##__)
	
#define ASSERT_CLASS(class_name, message)                                                                                                                                       \
	ASSERT_CALL_CLASS(class_name) {                                                                                                                                             \
		holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                \
									   __class_##class_name##_exists__ == true });                                                                                              \
	} END;                                                                                                                                                                      \
	holder->m_assertions.push_back(utf::Assertion<T>{ std::string(message) + "\n", "", 0, 0,                                                                                    \
									   __class_##class_name##_exists__ == true });                                                                                              \
	ASSERT_CALL_CLASS(class_name)
    
#define ASSERT_CALL_CLASS(struct_name)                                                                                                                                          \
	utf::call_if_defined<struct struct_name>([&](auto* p) {                                                                                                                     \
		using struct_name = std::decay_t<decltype(*p)>;                                                                                                                         \
		__class_##struct_name##_exists__ = true;

#define END })

#define CHECK_FUNC_SIGNATURE(function_name, signature)                                                                                                                          \
	std::string(typeid(function_name).name()) == std::string(typeid(signature).name()).substr(1)  
	
#define CHECK_CLASS_METHOD(method_name)                                                                                                                                         \
	template<typename T, typename... Ts>                                                                                                                                        \
	auto __check_method_##method_name##__(T* obj, Ts... args) -> decltype(obj->method_name(args...)) {                                                                          \
		return obj->method_name(args...);                                                                                                                                       \
	}                                                                                                                                                                           \
		                                                                                                                                                                        \
	auto __check_method_##method_name##__(...) -> std::string {                                                                                                                 \
		return std::string("Method ") + std::string(#method_name) + std::string(" is not defined!");                                                                            \
	}                                                                                                                                                                           \
	                                                                                                                                                                            \
	template<typename T, typename = std::true_type>                                                                                                                             \
	struct Alias_##method_name;                                                                                                                                                 \
	                                                                                                                                                                            \
	template<typename T>                                                                                                                                                        \
	struct Alias_##method_name<T, std::integral_constant<bool, utf::got_type<decltype(&T::method_name)>::value>> {                                                              \
		static const decltype(&T::method_name) value;                                                                                                                           \
	};                                                                                                                                                                          \
	                                                                                                                                                                            \
	struct AmbiguitySeed_##method_name {                                                                                                                                        \
		char method_name;                                                                                                                                                       \
	};                                                                                                                                                                          \
	                                                                                                                                                                            \
	template<typename T>                                                                                                                                                        \
	struct __has_method_##method_name##__ {                                                                                                                                     \
		static const bool value = utf::has_member<Alias_##method_name<utf::ambiguate<T, AmbiguitySeed_##method_name>>,                                                          \
		                                     Alias_##method_name<AmbiguitySeed_##method_name>>::value;                                                                          \
	}
	
#define CHECK_CLASS_ATTRIBUTE(attribute_name)                                                                                                                                   \
	template<class T>                                                                                                                                                           \
	auto __check_attribute_##attribute_name##__(T* obj) -> decltype(obj->attribute_name) {                                                                                      \
		return obj->attribute_name;                                                                                                                                             \
	}                                                                                                                                                                           \
		                                                                                                                                                                        \
	auto __check_attribute_##attribute_name##__(...) -> std::string {                                                                                                           \
		return std::string("Attribute ") + std::string(#attribute_name) + std::string(" is not defined!");                                                                      \
	}                                                                                                                                                                           \
	                                                                                                                                                                            \
	template<typename T, typename = std::true_type>                                                                                                                             \
	struct Alias_##attribute_name;                                                                                                                                              \
	                                                                                                                                                                            \
	template<typename T>                                                                                                                                                        \
	struct Alias_##attribute_name<T, std::integral_constant<bool, utf::got_type<decltype(&T::attribute_name)>::value>> {                                                        \
		static const decltype(&T::attribute_name) value;                                                                                                                        \
	};                                                                                                                                                                          \
	                                                                                                                                                                            \
	struct AmbiguitySeed_##attribute_name {                                                                                                                                     \
		char attribute_name;                                                                                                                                                    \
	};                                                                                                                                                                          \
	                                                                                                                                                                            \
	template<typename T>                                                                                                                                                        \
	struct __has_attribute_##attribute_name##__ {                                                                                                                               \
		static const bool value = utf::has_member<Alias_##attribute_name<utf::ambiguate<T, AmbiguitySeed_##attribute_name>>,                                                    \
		                                     Alias_##attribute_name<AmbiguitySeed_##attribute_name>>::value;                                                                    \
	}
                                      
#define CHECK_CLASS_METHOD_SIGNATURE(method_name, signature, template_postfix)                                                                                                  \
	template<typename T, typename = std::true_type>                                                                                                                             \
	struct __has_method_with_sig_##template_postfix##__ : std::false_type {};                                                                                                   \
		                                                                                                                                                                        \
	template<typename T>                                                                                                                                                        \
	struct __has_method_with_sig_##template_postfix##__<T, std::integral_constant<bool,                                                                                         \
	                                       utf::sig_check<signature, &T::method_name>::value>> : std::true_type {}
	                                       
#define CLASS(class_name)                                                                                                                                                       \
	static bool __class_##class_name##_exists__ = false
	                                       
template<typename T>
constexpr void RUN(const std::unordered_map<std::string, std::vector<utf::Test<T>>>& suites, std::unordered_map<std::string, std::pair<bool, std::vector<std::string>>>& requirements) {

    for (const std::pair<std::string, std::vector<utf::Test<T>>>& suite : suites) {

        const std::vector<utf::Test<T>>& tests = suite.second;
        const std::string& suite_name = suite.first;

        for (size_t test_index = 0; test_index < tests.size(); test_index++) {

		    const utf::Test<T> test = tests[test_index];
		    utf::Holder<T> holder;
		    (test.m_functionTester)(&holder);
		    requirements[test.m_suiteName + "::" + test.m_testName].first = true;

		    for (size_t assert_index = 0; assert_index < holder.m_assertions.size(); assert_index++) {
		    	
		        const utf::Assertion<T> assertion = holder.m_assertions[assert_index];
		        requirements[test.m_suiteName + "::" + test.m_testName].first &= assertion.m_check;
		        if (!assertion.m_check) {
		        	requirements[test.m_suiteName + "::" + test.m_testName].second.push_back(assertion.m_errorMessage);
		        }
		        
		    }

	    }
    }
}

                                                                       
/*
template<typename T>
constexpr s8 RUN(const std::unordered_map<std::string, std::vector<utf::Test<T>>>& suites) {

	s8 ret = 0;

	if (suites.empty()) {
		std::cout << "\nNo tests found.\n\n";
		return ret;
	}

    std::cout << "\n";
    std::vector<std::string> failed_tests;

    for (const std::pair<std::string, std::vector<utf::Test<T>>>& suite : suites) {

        std::cout << "[====================================================]\n";
        const std::vector<utf::Test<T>>& tests = suite.second;
        const std::string& suite_name = suite.first;
        std::cout << "[==========] Running " << tests.size() << " tests from " << suite_name << " suite.\n\n";

        for (size_t test_index = 0; test_index < tests.size(); test_index++) {
	    
            bool test_ok = true;
		    const utf::Test<T> test = tests[test_index];
		    utf::Holder<T> holder;
		    (test.function_to_test)(&holder);
		    std::string format_assert = holder.m_assertions.size() != 1 ? " asserts" : " assert";
		    std::cout << "[----------] " << holder.m_assertions.size() << format_assert << " from " << test.suite_name << "::" << test.test_name << "\n";
		    std::cout << "[    RUN   ] " << test.suite_name << "::" << test.test_name << "\n";

		    for (size_t assert_index = 0; assert_index < holder.m_assertions.size(); assert_index++) {
		    	
		    
		        const utf::Assertion<T> assertion = holder.m_assertions[assert_index];
		        
		        if (!assertion.m_check) {
		        	if (test_ok == true) {
		        		std::cerr << "error: Some asserts failed with the following error messages:" << "\n";
		        		test_ok = false;
		        	}
				    std::cerr << "Error " << (assert_index + 1) << ": " << "<------ " << assertion.m_errorMessage << " ------>" << "\n";
		        }
		        
		    }
		    
		    if (test_ok == true) {
			    std::cout << "[    OK    ] " << test.suite_name << "::" << test.test_name << "\n\n";
		    } else {
			    std::cout << "[  FAILED  ] " << test.suite_name << "::" << test.test_name << "\n\n";
			    failed_tests.push_back(test.suite_name + "::" + test.test_name);
		    }
		    
	    }
	    
	    std::cout << "[==========] Begin status for " << suite_name << " suite\n\n";
	    u16 nr_passed = tests.size() - failed_tests.size();
	    std::string format_test_passed = nr_passed != 1 ? " tests" : " test";
	    std::cout << "[  PASSED  ] " << tests.size() - failed_tests.size() << format_test_passed << "\n";
	    
	    if (!failed_tests.empty()) {
		    std::string format_test_failed_lowercase = failed_tests.size() != 1 ? " tests" : " test";
		    std::cout << "[  FAILED  ] " << failed_tests.size() << format_test_failed_lowercase << ", listed below:\n";
		    std::cout << "[  FAILED  ] ";
		    
		    for (const std::string& failed_test : failed_tests) {
			    std::cout << failed_test << "  ";
		    }
		    
		    std::cout << "\n\n";
		    std::string format_test_failed_uppercase = failed_tests.size() != 1 ? " TESTS" : " TEST";
		    std::cout << failed_tests.size() << format_test_failed_uppercase << " FAILED\n\n";
	    } else {
		    std::cout << "\nALL TESTS PASSED\n\n";
	    }
	    
	    std::cout << "[==========] End status for " << suite_name << " suite\n\n\n\n";
	    failed_tests.clear();
	    
    }

    return ret;
}
*/

#endif

