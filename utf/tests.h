/**
	@function    CLASS                            Create a tester for a class
	@param       class_name                       Name of the class which need to be tested.
*/
CLASS(Test);

/**
	@function    CHECK_CLASS_ATTRIBUTE            Create a tester for an attribute in any class.
	@param       attribute_name                   Name of the attribute which need to be tested.
	
	@note                                         This function creates a function called '__check_attribute_##attribute_name##__'.
												  With this function we can get values from our attributes from a class because
												  we can't use the standard way. This function needs only one parameters, the address
												  of a class object.
*/
CHECK_CLASS_ATTRIBUTE(tmp);
CHECK_CLASS_ATTRIBUTE(ftmp);

/**
	@function    CHECK_CLASS_METHOD               Create a tester for a method in any class.
	@param       method_name                      Name of the method which need to be tested.
	
	@note                                         This function creates a function called '__check_method_##method_name##__'.
												  With this function we can get return values from our methods from a class because
												  we can't use the standard way. First parameter of this function is the address
												  of a class object. Then, we need to pass the parameters of the method if they exist.
*/
CHECK_CLASS_METHOD(print);
CHECK_CLASS_METHOD(sum);

/**
	@function    CHECK_CLASS_METHOD_SIGNATURE     Create a tester for method signature in any class.
	@param       method_name                      Name of the method which need to be tested.
	@param       signature                        Signature for method to be checked.
	@param       template_postfix                 It can be any valid name.
	
	@note                                         Signature of the method need to be in function pointer format, but
												  instead of a '*' you need to put 'T::*'
*/
CHECK_CLASS_METHOD_SIGNATURE(print, void (T::*)(), rv_print_);
CHECK_CLASS_METHOD_SIGNATURE(sum, int (T::*)(int, int), ri_sum_ii);

/**
	When you try to check if a function is defined or it has a given signature, then you need to define
	it and also you need to put the weak atttribute.
*/
int multiply(int, int) __attribute__((weak));

/**
	@function    TEST                             Create a test which need to be passed as REQUIRED parameter in test file (vpl_evaluate.cases).
	@param       suite_name                       Name of the suite (it names something big to be tested). 
	@param       test_name                        Name of the test (it names a subclass of a suite).
*/
TEST(Function, Name_multiply) {
	
	/**
		@function    ASSERT_FUNCTION                  Checks if a function has been defined.
		@param       function_name                    Name of the function to be checked. 
		@param       message                          Message to be printed if something goes wrong.
	*/
    ASSERT_FUNCTION(multiply, "Function 'multiply' HAS NOT BEEN defined!") {
		/**
			@function    ASSERT_FUNCTION_SIGNATURE        Checks if a function has been defined.
			@param       function_name                    Name of the function to be checked.
			@param       signature                        Signature for function to be checked.
			@param       message                          Message to be printed if something goes wrong.
			
			@note                                         Signature of the function need to be in function pointer format.
		*/
    	ASSERT_FUNCTION_SIGNATURE(multiply, int(*)(int, int), "Function 'multiply' DOES NOT have the given signature!") {
    		int i_val = 3;
    		int f_val = 2;
    		int result = multiply(i_val, f_val);
    		int expected_result = 6;
			/**
				@functions   ASSERT_EQUAL                     Test if 2 parameters are equal.
							 ASSERT_NOT_EQUAL				  Test if 2 parameters are not equal.
							 ASSERT_LESS                      Test if first argument is less than the second argument.
							 ASSERT_GREATER                   Test if first argument is greater than the second argument.
							 ASSERT_LESS_OR_EQUAL             Test if first argument is less than or equal with the second argument.
							 ASSERT_GREATER_OR_EQUAL          Test if first argument is greater than or equal with the second argument.
				@param       first_argument                   First argument of the comparison operation.
				@param       second_argument                  Second argument of the comparison operation.
				@param       message                          Message to be printed if something goes wrong.

			*/
    		ASSERT_EQUAL(result, expected_result, "Function 'multiply' DOES NOT return the required result!");
    	}
    }
    
}

TEST(Class_Test, Class_Existance) {

	/**
		@function    ASSERT_CLASS                     Checks if a class has been defined.
		@param       class_name                       Name of the class to be checked. 
		@param       message                          Message to be printed if something goes wrong.
	*/
	ASSERT_CLASS(Test, "Class 'Test' HAS NOT BEEN defined!") {
	
	} END;
	
}

TEST(Class_Test, Attributes_tmp_ftmp_Existance) {
	
	/**
		@function    ASSERT_CLASS_ATTRIBUTE           Checks if an attribute in a given class has been defined (depends on CHECK_CLASS_ATTRIBUTE).
		@param       class_name                       Name of the class to be checked.
		@param       attribute_name                   Name of the attribute in class 'class_name' to be checked. 
		@param       message                          Message to be printed if something goes wrong.
		
		@note                                         This function depends on CHECK_CLASS_ATTRIBUTE function.
	*/
	ASSERT_CLASS_ATTRIBUTE(Test, tmp, "Class 'Test' HAS NOT 'tmp' attribute!") {
	
	} END;
	
	ASSERT_CLASS_ATTRIBUTE(Test, ftmp, "Class 'Test' HAS NOT 'ftmp' attribute!") {
	
	} END;
	
}

TEST(Class_Test, Methods_print_sum_Existance) {
	
	/**
		@function    ASSERT_CLASS_METHOD              Checks if a method in a given class has been defined.
		@param       class_name                       Name of the class to be checked.
		@param       method_name                      Name of the method in class 'class_name' to be checked. 
		@param       message                          Message to be printed if something goes wrong.
		
		@note                                         This function depends on CHECK_CLASS_METHOD function.
	*/
	ASSERT_CLASS_METHOD(Test, print, "Class 'Test' HAS NOT 'print' method!") {
	
	} END;
	
	ASSERT_CLASS_METHOD(Test, sum, "Class 'Test' HAS NOT 'sum' method!") {
	
	} END;
	
}

TEST(Class_Test, Methods_print_sum_Signatures) {
	
	/**
		@function    ASSERT_CLASS_METHOD_SIGNATURE    Checks if a method in a given class has a given signature.
		@param       class_name                       Name of the class to be checked.
		@param       method_name                      Name of the method in class 'class_name' to be checked. 
		@param       template_postfix                 It can be any valid name, but need to be the same name when define CHECK_CLASS_METHOD_SIGNATURE.
		@param       message                          Message to be printed if something goes wrong.
		
		@note                                         This function depends on CHECK_CLASS_METHOD_SIGNATURE function. 
	*/		
	ASSERT_CLASS_METHOD_SIGNATURE(Test, sum, ri_sum_ii, "Signature for method 'sum' in class 'Test' IS NOT correct!") {
	
	} END;
	
	ASSERT_CLASS_METHOD_SIGNATURE(Test, print, rv_print_, "Signature for method 'print' in class 'Test' IS NOT correct!") {
	
	} END;	
		
}

TEST(Class_Test, Default_Constructor) {	

	/**
		@function    ASSERT_CLASS_CONSTRUCTOR         Checks if a constructor in a given class has been defined.
		@param       message                          Message to be printed if something goes wrong.
		@param       class_name                       Name of the class to be checked.
		@param       __VA_ARGS__                      Type of parameters in the constructor. If default constructor
													  is checked, then no parameters needed.
													  
		@note                                         Note that if we want to check values of an attribute or return value of
													  a method, this can't be done in the standard way. To access an attribute or
													  to get the value returned from a function we need to use special functions
													  which our CHECK_CLASS_ATTRIBUTE and CHECK_CLASS_METHOD functions creates after
													  we call them. Standard name of this functions are '__check_attribute_##attribute_name##__'
													  for attributes and '__check_method_##method_name##__' for methods, where attribute_name and
													  method_name are the name of the attribute and method respectivly.
	*/
	ASSERT_CLASS_CONSTRUCTOR("Default constructor DOES NOT exist!", Test) {
		Test test_default;
		auto tmp = __check_attribute_tmp__(&test_default);
		auto ftmp = __check_attribute_ftmp__(&test_default);
		auto sum = __check_method_sum__(&test_default, 2, 3);
		ASSERT_EQUAL(tmp, 10, "Default constructor DOES NOT initialize the attribute 'tmp' correctly!");
		ASSERT_EQUAL(ftmp, 12.45f, "Default constructor DOES NOT initialize the attribute 'ftmp' correctly!");
		ASSERT_EQUAL(sum, 15, "Method 'sum' from class 'Test' DOES NOT return the required result!");
	} END;
	
}

TEST(Class_Test, Two_Arguments_Constructor) {
		
	ASSERT_CLASS_CONSTRUCTOR("Constructor with args (int, float) DOES NOT exist!", Test, int, float) {
		Test test_int_float(1, 1.5f);
		auto tmp = __check_attribute_tmp__(&test_int_float);
		auto ftmp = __check_attribute_ftmp__(&test_int_float);
		auto sum = __check_method_sum__(&test_int_float, 2, 3);
		ASSERT_EQUAL(tmp, 1, "Constructor with args (int, float) DOES NOT initialize the attribute 'tmp' correctly!");
		ASSERT_EQUAL(ftmp, 1.5f, "Constructor with args (int, float) DOES NOT initialize the attribute 'ftmp' correctly!");	
	} END;
	
}

