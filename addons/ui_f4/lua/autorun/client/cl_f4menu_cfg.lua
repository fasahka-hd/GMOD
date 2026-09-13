F4Menu = F4Menu or {}

F4Menu.Commands = {
    {
        category = 'Денежные операции';
        content = {
            {
                name = 'Выкинуть деньги';
                click = function()
                    local mm = LocalPlayer():GetMoney()
                    ui.NumberRequest('Выбросить пачку денег', 'Введите сумму\n У вас $' .. mm, 2, 1, LocalPlayer():GetMoney(), function(a)
                        cmd.Run('dropmoney', tostring(a))
                    end)
                end;
            };

            {
                name = 'Передать деньги';
                click = function()
                    local mm = LocalPlayer():GetMoney()
                    ui.NumberRequest('Передать деньги', 'Введите сумму\n У вас $' .. mm, 2, 1, LocalPlayer():GetMoney(), function(a)
                        cmd.Run('give', tostring(a))
                    end)
                end;
            };

        };
    };

    {
        category = 'Персонаж';
        content = {
            {
                name = 'Установить название професии';
                click = function()
                    ui.StringRequest('Установить название профессии', 'Введите новое название профессии', '', function(a)
                        cmd.Run('job', a)
                    end)
                end;
            };

            {
                name = 'Сменить имя';
                click = function()
                    ui.StringRequest('Сменить ролевое имя', 'Введите новое ролевое имя', '', function(a)
                        cmd.Run('rpname', a)
                    end)
                end;
            };
        };
    };

    {
        category = 'Ролеплей';
        content = {
            {
                name = 'Продать все двери';
                click = function()
                    cmd.Run('sellall')
                end;
            };

            {
                name = 'Выбросить текущее оружие';
                click = function()
                    cmd.Run('drop')
                end;
            };

            {
                name = 'Нанять работника';
                click = function()
                    cmd.Run('hire')
                end;
            };

            {
                name = 'Уволить работника';
                click = function()
                    ui.PlayerRequest(function(v)
                        ui.StringRequest('Уволить игрока', 'Введите причину', '', function(a)
                            if IsValid(v) then
                                cmd.Run('demote', v:SteamID(), a)
                            end
                        end)
                    end)
                end;
            };

            {
                name = 'Заказать убийство';
                click = function()
                    ui.PlayerRequest(function(v)
                        ui.StringRequest('Заказать убийство', 'Укажите цену за убийство (' .. rp.FormatMoney(rp.cfg.HitMinCost) .. ' - ' .. rp.FormatMoney(rp.cfg.HitMaxCost) .. ')?', '', function(a)
                            if IsValid(v) then
                                cmd.Run('hit', v:SteamID(), a)
                            end
                        end)
                    end)
                end;
            };
        };
    };

    {
        category = 'Рандом';
        content = {
            {
                name = 'Случайное число';
                click = function()
                    cmd.Run('roll')
                end;
            };

            {
                name = 'Бросить кубики';
                click = function()
                    cmd.Run('dice')
                end;
            };

            {
                name = 'Вытянуть карту';
                click = function()
                    cmd.Run('cards')
                end;
            };

            {
                name = 'Подбросить монетку';
                click = function()
                    cmd.Run('coins')
                end;
            };
        };
    };

}
