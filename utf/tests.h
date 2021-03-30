/**
 * Unit Test Framework for compile time checking in VPL
 * @Copyright (C) 2020 Andrei-Edward Popa
 * @Author Andrei-Edward Popa <andrei_edward.popa@upb.ro>
 */


REFLECT_CLASS(Test) {
	REFLECT_ATTRIBUTE(tmp, int);
	REFLECT_ATTRIBUTE(ftmp, float);
	REFLECT_METHOD(print, void);
	REFLECT_METHOD(sum, int, int, int);
	REFLECT_OPERATOR(operator+, operatorPlus, Test, const Test&);
};

REFLECT_FUNCTION(multiply, int, int, int);


TEST(Segmentation, Fault) {

	REFLECT_SEGMENTATION_FAULT("Test #1", "Segmentation fault message for Test #1.");
	
}


TEST(Function, Multiply) {

	// Generate SIGSEGV
	// int *p = NULL;
	// *p = 1;
	
	ASSERT_FUNCTION(multiply, "Check existence or signature for function 'multiply'") BEGIN {
	
		ASSERT_EQUAL(multiply(3, 2), 6, "Function 'multiply' doesn't return the required result!");
		
	} END
    
}


TEST(Test, Existence) {

	ASSERT_CLASS(Test, "Class 'Test' doesn't exist!");
	
}


TEST(Test, Attributes_tmp_ftmp) {
	
	ASSERT_ATTRIBUTE(Test, tmp, "Check existence or type for attribute 'tmp' from class 'Test'!");	
	ASSERT_ATTRIBUTE(Test, ftmp, "Check existence or type for attribute 'ftmp' from class 'Test'");
	
}


TEST(Test, Methods_print_sum) {
	
	ASSERT_METHOD(Test, print, "Check existence or signature for method 'print' from class 'Test'!");
	ASSERT_METHOD(Test, sum, "Check existence or signature for method 'sum' from class 'Test'!");
	
}

TEST(Test, OperatorPlus) {
	
	ASSERT_OPERATOR(Test, operatorPlus, "Check existence or signature for operator 'operator+' from class 'Test'!");
	
}


TEST(Test, DefaultConstructor) {	

	ASSERT_CONSTRUCTOR("Default constructor doesn't exist!", Test) BEGIN {
		Test test_default;
		auto tmp = TestWrapper::tmp(&test_default);
		auto ftmp = TestWrapper::ftmp(&test_default);
		auto sum = TestWrapper::sum(&test_default, 2, 3);
		ASSERT_EQUAL(tmp, 10, "Default constructor doesn't initialize the attribute 'tmp' correctly!");
		ASSERT_EQUAL(ftmp, 12.45f, "Default constructor doesn't initialize the attribute 'ftmp' correctly!");
		ASSERT_EQUAL(sum, 15, "Method 'sum' from class 'Test' doesn't return the required result!");
	} END
	
}


TEST(Test, TwoArgumentsConstructor) {
		
	ASSERT_CONSTRUCTOR("Constructor with args (int, float) doesn't exist!", Test, int, float) BEGIN {
		Test test_int_float(1, 1.5f);
		auto tmp = TestWrapper::tmp(&test_int_float);
		auto ftmp = TestWrapper::ftmp(&test_int_float);
		auto sum = TestWrapper::sum(&test_int_float, 2, 3);
		ASSERT_EQUAL(tmp, 1, "Constructor with args (int, float) doesn't initialize the attribute 'tmp' correctly!");
		ASSERT_EQUAL(ftmp, 1.5f, "Constructor with args (int, float) doesn't initialize the attribute 'ftmp' correctly!");
		ASSERT_EQUAL(sum, 6, "Method 'sum' from class 'Test' doesn't return the required result!");
	} END
	
}

