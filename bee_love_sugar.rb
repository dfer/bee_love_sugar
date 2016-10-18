require 'csv'

# Смотрим кол-во параметров в командной строке
if ARGV.size != 2
	exit(1)
end

# Проверяем есть ли такие файлы перед их открытием 
if File.exist?(ARGV[0]) == false or File.exist?(ARGV[1]) == false
	exit(2)
end

# Получаем абсолютные пути к файлам
pollen_file = File.expand_path(ARGV[0])
harvest_file = File.expand_path(ARGV[1])

pollens = Hash.new
harvest = []

CSV.foreach(pollen_file, headers: true) do |row|
	# Проверям на корректность данные.
	if row['id'].nil? or row['name'].nil? or row['sugar_per_mg'].nil?
		exit(3)
	end 
	pollens[row['id'].to_i] = {:name=>row['name'], :sugar_per_mg=>row['sugar_per_mg'].to_i}
end

CSV.foreach(harvest_file, headers: true) do |row|
	# Проверяем что данные по полетам пчел корректны.
	if row['bee_id'].nil? or row[' day'].nil? or row[' pollen_id'].nil? or row[' miligrams_harvested'].nil?
		exit(4)
	end
	harvest << {:bee_id=>row['bee_id'].to_i, :day=>row[' day'], :pollen_id=>row[' pollen_id'].to_i, :mg=>row[' miligrams_harvested'].to_f}
end

# Question 1 - Из пыльцы какого типа было получено больше всего сахара?
# Найдем суммарную массу каждого типа пыльцы
pollens_weight = Hash.new(0)

harvest.each{|x| pollens_weight[x[:pollen_id]] += x[:mg]}

# Переводим пыльцу в сахар и находим максимум
pollens_weight_sugar = Hash.new
max_sugar_weght, max_pollen_id = 0, nil

pollens_weight.each do |key, value|
	pollens_weight_sugar[key] = value * pollens[key][:sugar_per_mg]
	
	if max_sugar_weght < pollens_weight_sugar[key]
		max_sugar_weght = pollens_weight_sugar[key]
		max_pollen_id = key
	end
end

puts '-----'
puts 'Pollen with max sugar weight is: '+pollens[max_pollen_id][:name]+' (pollen_id = '+max_pollen_id.to_s+')'
puts '-----'

# Question 2 - Какая пыльца была наиболее популярна среди пчел?
# У нас уже есть суммарная масса каждого типа пыльцы из решения для Ответа 1. Найдем максимум
max_weght, max_pollen_id = 0, nil

pollens_weight.each do |key, value|
	if max_weght < value
		max_weght = value
		max_pollen_id = key
	end
end

puts 'Most popular pollen is: '+pollens[max_pollen_id][:name]+' (pollen_id = '+max_pollen_id.to_s+')'
puts '-----'

# Question 3 - Какой день был самым лучшим для сбора урожая? Какой был худшим?
# (Было бы здорово увидеть таблицу или график, который показывает общее количество сахара за каждый день)

# Считаем кол-во сахара каждый день
sugar_days = Hash.new(0)
harvest.each do |x|
	sugar_days[x[:day]] += x[:mg] * pollens[x[:pollen_id]][:sugar_per_mg]
end

# Получим отсортированный по значению массив из массивов [ [key, value], [key, value], ... ]
# Можно сделать O(n), если искать просто максимум и минимум в хэше
temp_array = sugar_days.sort_by{ |key, value| value } 

puts 'Best day is: '+temp_array[temp_array.size-1][0]
puts 'Bad day is: '+temp_array[0][0]

puts 'Table of days:'
sugar_days.each do |key, value|
	puts '| ' + key + ' | ' + value.round(2).to_s + ' mg |'
end
puts '-----'

# Question 4 - Какая пчела была наиболее эффективной? Какая была наименее эффективной? 
# Эффективность измеряется как среднее количество сахара за все рабочие дни (Было бы здорово увидеть таблицу для всех пчел).

# Считаем кол-во сахара полученное каждой пчелой и кол-во дней когда она работала
bee_sugar_weight, bee_work_days = Hash.new(0), Hash.new(0)

harvest.each do |x|
	bee_sugar_weight[x[:bee_id]] += x[:mg] * pollens[x[:pollen_id]][:sugar_per_mg]
	bee_work_days[x[:bee_id]] += 1
end

# Находим среднее кол-во сахара в день для каждой пчелы
bee_avr_sugar_by_day = Hash.new(0)

bee_sugar_weight.each do |key, value|
	if bee_work_days[key] > 0
		bee_avr_sugar_by_day[key] = value / bee_work_days[key]
	else
		bee_avr_sugar_by_day[key] = 0
	end
end

# Получим отсортированный по значению массив из массивов [ [key, value], [key, value], ... ]
# Можно сделать O(n), если искать просто максимум и минимум в хэше
temp_array = bee_avr_sugar_by_day.sort_by{ |key, value| value } 

puts 'Best bee is: '+temp_array[temp_array.size-1][0].to_s
puts 'Bad bee is: '+temp_array[0][0].to_s

puts 'Table of bees:'
bee_avr_sugar_by_day.each do |key, value|
	puts '| ' + key.to_s + ' | ' + value.round(2).to_s + ' mg |'
end