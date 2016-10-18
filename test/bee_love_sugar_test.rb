require 'test/unit'

class CsvTest < Test::Unit::TestCase
	$file_path = File.expand_path('bee_love_sugar.rb')
	
	# Не переданы параметры
	def test_no_params
		cmd = "ruby "+$file_path
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Передан только 1 параметр
	def test_one_params
		cmd = "ruby "+$file_path+" param1"
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Передано 3 параметра
	def test_three_params
		cmd = "ruby "+$file_path+" param1 param2 param3"
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Нет файлов переданных в качестве параметров
	def test_no_both_csv_files
		file_1, file_2 = rand(10).to_s+'.csv', rand(10).to_s+'.csv'
		
		cmd = "ruby "+$file_path+" "+file_1+" "+file_2
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Нет одного файла переданного в качестве параметра
	def test_no_one_csv_files
		file_1, file_2 = 'test/csv/pollens_correct.csv', rand(10).to_s+'.csv'
		
		cmd = "ruby "+$file_path+" "+file_1+" "+file_2
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Некорректные данные в файле pollens.csv
	def test_wrong_data_in_pollens_file
		file_1, file_2 = 'test/csv/pollens_0.csv', 'test/csv/harvest_correct.csv'
		
		cmd = "ruby "+$file_path+" "+file_1+" "+file_2
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Некорректные данные в файле harvest.csv
	def test_wrong_data_in_harvest_file
		file_1, file_2 = 'test/csv/pollens_correct.csv', 'test/csv/harvest_0.csv'
		
		cmd = "ruby "+$file_path+" "+file_1+" "+file_2
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
	
	# Некорректные данные в файлах pollens.csv и harvest.csv
	def test_wrong_data_in_both_files
		file_1, file_2 = 'test/csv/pollens_0.csv', 'test/csv/harvest_0.csv'
		
		cmd = "ruby "+$file_path+" "+file_1+" "+file_2
		system_result = system(cmd)
		assert_equal(system_result, false)
	end
end