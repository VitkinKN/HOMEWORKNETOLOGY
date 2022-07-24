# HOMEWORK_PROVAIDERS_TERRAFOMS_OWNS_7_6_(VITKIN_K_N)

### 1. Найти исходный код AWS и нужные ресурсы в исходном коде. 
- *Клонируем репозиторий*
```
konstantin@konstantin-forever ~ $ git clone git@github.com:VitkinKN/terraform-provider-aws.git
Клонирование в «terraform-provider-aws»…
remote: Enumerating objects: 391515, done.
remote: Counting objects: 100% (37/37), done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 391515 (delta 13), reused 26 (delta 8), pack-reused 391478
Получение объектов: 100% (391515/391515), 373.21 MiB | 2.91 MiB/s, готово.
Определение изменений: 100% (280278/280278), готово.
Проверка соединения… готово.
```
- *Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.*

- *[все доступные data_source в коде](https://github.com/hashicorp/terraform-provider-aws/blob/34af55ac41107466021f6421f63ea6712c671053/internal/provider/provider.go#L415)*

- *[все доступные resource в коде](https://github.com/hashicorp/terraform-provider-aws/blob/34af55ac41107466021f6421f63ea6712c671053/internal/provider/provider.go#L913)*

###### Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name*

- *С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано.*
- *[name конфликтует c name_prefix: cтрока в коде](https://github.com/hashicorp/terraform-provider-aws/blob/710ca409193c7405fc39a5024a5abdd317ab9a97/internal/service/ec2/vpc_security_group.go#L68)*
- *Какая максимальная длина имени?*
- *[name максимальная длинна](https://github.com/hashicorp/terraform-provider-aws/blob/eab0e21bbb110b8e42b90e2d1e0b2e83e13b5a31/internal/service/autoscaling/group_test.go#L4129)*
- *Какому регулярному выражению должно подчиняться имя?*
- *В старых коммитах*
```
func validateSQSQueueName(v interface{}, k string) (ws []string, errors []error) {
	value := v.(string)
	if len(value) > 80 {
		errors = append(errors, fmt.Errorf("%q cannot be longer than 80 characters", k))
	}

	if !regexp.MustCompile(`^[0-9A-Za-z-_]+(\.fifo)?$`).MatchString(value) {
		errors = append(errors, fmt.Errorf("only alphanumeric characters and hyphens allowed in %q", k))
	}
	return
}
```

___
