class_name GdUnitExampleTest
extends GdUnitTestSuite


func test_list_dir() -> void:
	var result := edir.list_recursive(
		"res://tests/cases/dir_extensions/list_dir_recursive/assets/1/"
	)
	assert_int(len(result)).is_equal(8)

	@warning_ignore("untyped_declaration")  # I cannot figure out the type of x
	var files := result.filter(func(x): return x.is_file).map(func(x): return x.file)
	assert_array(files).contains_exactly(
		["file.txt", "file2.txt", "file3.txt", "file3.txt", "file4.txt"]
	)

	@warning_ignore("untyped_declaration")  # I cannot figure out the type of x
	var dirs := result.filter(func(x): return x.is_dir).map(func(x): return x.file)
	assert_array(dirs).contains_exactly(["sub-dir", "sub-dir-2", "sub-dir-3"])

	@warning_ignore("untyped_declaration")  # I cannot figure out the type of x
	var raw_dirs := result.filter(func(x): return x.is_dir)
	assert_str(raw_dirs[0].path).is_equal(
		"res://tests/cases/dir_extensions/list_dir_recursive/assets/1/sub-dir"
	)
