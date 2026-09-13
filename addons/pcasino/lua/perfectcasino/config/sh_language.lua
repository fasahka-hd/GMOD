--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Меню настроек
PerfectCasino.Translation.ConfigMenu = {}
PerfectCasino.Translation.ConfigMenu.Title = "pCasino Создатель Сущностей"
PerfectCasino.Translation.ConfigMenu.EntityToConfig = "Сущность для настройки"
PerfectCasino.Translation.ConfigMenu.EntityToConfigComboBox = "Выберите сущность!"
PerfectCasino.Translation.ConfigMenu.RewardComboBox = "Выберите награду!"
PerfectCasino.Translation.ConfigMenu.SpawnEntity = "Создать сущность"
PerfectCasino.Translation.ConfigMenu.ResetButton = "Назад"
PerfectCasino.Translation.ConfigMenu.AddComboButton = "Новая комбинация"
PerfectCasino.Translation.ConfigMenu.TableHeaderChance = "Комбинация"
PerfectCasino.Translation.ConfigMenu.TableHeaderActions = "Действия"
PerfectCasino.Translation.ConfigMenu.TakeoutBonusMultiplier = "Множитель бонуса выкупа:"
PerfectCasino.Translation.ConfigMenu.IsJackpot = "Джекпот:"
PerfectCasino.Translation.ConfigMenu.Delete = "УДАЛИТЬ"

-- Сущности
PerfectCasino.Translation.Entities = {}
PerfectCasino.Translation.Entities["pcasino_slot_machine"] = "Базовый игровой автомат"
PerfectCasino.Translation.Entities["pcasino_wheel_slot_machine"] = "Колёсный игровой автомат"
PerfectCasino.Translation.Entities["pcasino_roulette_table"] = "Стол для рулетки"
PerfectCasino.Translation.Entities["pcasino_blackjack_table"] = "Стол для блэкджека"
PerfectCasino.Translation.Entities["pcasino_mystery_wheel"] = "Колесо тайн"
PerfectCasino.Translation.Entities["pcasino_sign_plaque"] = "Табличка"
PerfectCasino.Translation.Entities["pcasino_sign_stand"] = "Стенд с вывеской"
PerfectCasino.Translation.Entities["pcasino_sign_wall_logo"] = "Настенный логотип"
PerfectCasino.Translation.Entities["pcasino_sign_interior_standing"] = "Напольная интерьерная вывеска"
PerfectCasino.Translation.Entities["pcasino_sign_interior_wall"] = "Настенная интерьерная вывеска"
PerfectCasino.Translation.Entities["pcasino_chair"] = "Стул"
PerfectCasino.Translation.Entities["pcasino_prize_plinth"] = "Постамент для призов"
PerfectCasino.Translation.Entities["pcasino_npc"] = "НПС"

-- Награды
PerfectCasino.Translation.Rewards = {}
PerfectCasino.Translation.Rewards["nothing"] = "Ничего"
PerfectCasino.Translation.Rewards["money"] = "Деньги"
PerfectCasino.Translation.Rewards["jackpot"] = "Джекпот"
PerfectCasino.Translation.Rewards["prize_wheel"] = "Бесплатное вращение Колеса тайн"
PerfectCasino.Translation.Rewards["weapon"] = "Оружие"
PerfectCasino.Translation.Rewards["health"] = "Здоровье"
PerfectCasino.Translation.Rewards["armor"] = "Броня"
PerfectCasino.Translation.Rewards["kill"] = "Убийство"
PerfectCasino.Translation.Rewards["setmodel"] = "Сменить модель игрока"
PerfectCasino.Translation.Rewards["ps1_points"] = "[Магазин очков 1] Очки"
PerfectCasino.Translation.Rewards["ps1_item"] = "[Магазин очков 1] Предмет"
PerfectCasino.Translation.Rewards["ps2_points"] = "[Магазин очков 2] Очки"
PerfectCasino.Translation.Rewards["ps2_item"] = "[Магазин очков 2] Предмет"
PerfectCasino.Translation.Rewards["ps2_prempoints"] = "[Магазин очков 2] Премиум очки"
PerfectCasino.Translation.Rewards["pssh_points"] = "[Магазин очков SH] Очки"
PerfectCasino.Translation.Rewards["pssh_item"] = "[Магазин очков SH] Предмет"
PerfectCasino.Translation.Rewards["pssh_prempoints"] = "[Магазин очков SH] Премиум очки"
PerfectCasino.Translation.Rewards["wcd_givecar"] = "[Автодилер William's] Выдать машину"
PerfectCasino.Translation.Rewards["fcd_givecar"] = "[Автодилер Fresh] Выдать машину"
PerfectCasino.Translation.Rewards["bwe_givexp"] = "[BrickWall's Essentials] Выдать опыт"
PerfectCasino.Translation.Rewards["mtkn_tokens"] = "[mTokens] Выдать токены"
PerfectCasino.Translation.Rewards["srp_givecar"] = "[SantosRP] Выдать машину"
PerfectCasino.Translation.Rewards["bc_credits"] = "[Brick's Credits] Кредиты"
PerfectCasino.Translation.Rewards["3dcd_givecar"] = "[3D Автодилер 2] Выдать машину"
PerfectCasino.Translation.Rewards["vcmod_givecar"] = "[VCMod] Выдать машину"

-- Опции настроек
PerfectCasino.Translation.Config = {}
PerfectCasino.Translation.Config.general = {}
PerfectCasino.Translation.Config.general.Title = "Основные настройки"
PerfectCasino.Translation.Config.general.Desc = "Основные игровые настройки"
PerfectCasino.Translation.Config.general.betPeriod = "Период после первой ставки до начала игры"
PerfectCasino.Translation.Config.general.useFreeSpins = "Возможность использовать выигранные бесплатные вращения на этом колесе"
PerfectCasino.Translation.Config.general.rope = "Добавить верёвку по краю"
PerfectCasino.Translation.Config.general.model = "Модель для отображения"
PerfectCasino.Translation.Config.general.spin = "Заставить платформу вращаться"
PerfectCasino.Translation.Config.general.bow = "Миленький бантик сверху (Не будет работать с моделями, у которых увеличены коллизии)"
PerfectCasino.Translation.Config.general.bowOffset = "Если бантик включён, здесь можно задать вертикальное смещение (Отрицательное или положительное)"
PerfectCasino.Translation.Config.general.limitUse = "Разрешить использование только одного автомата за раз"

PerfectCasino.Translation.Config.buySpin = {}
PerfectCasino.Translation.Config.buySpin.Title = "Настройки покупки вращений"
PerfectCasino.Translation.Config.buySpin.Desc = "Покупка вращений для колеса"
PerfectCasino.Translation.Config.buySpin.buy = "Возможность купить вращение за деньги"
PerfectCasino.Translation.Config.buySpin.cost = "Если да, цена одного вращения"

PerfectCasino.Translation.Config.jackpot = {}
PerfectCasino.Translation.Config.jackpot.Title = "Настройки джекпота"
PerfectCasino.Translation.Config.jackpot.Desc = "Настройки джекпота"
PerfectCasino.Translation.Config.jackpot.toggle = "Можно ли выиграть джекпот?"
PerfectCasino.Translation.Config.jackpot.startValue = "Начальная сумма джекпота"
PerfectCasino.Translation.Config.jackpot.betAdd = "Процент от ставки, добавляемый в джекпот. 0.1 = 10%, 0.5 = 50%, 1 = 100% и т.д."

PerfectCasino.Translation.Config.reward = {}
PerfectCasino.Translation.Config.reward.Title = "Настройки наград"
PerfectCasino.Translation.Config.reward.Desc = "Выберите, какие комбинации наград выдаются"

PerfectCasino.Translation.Config.combo = {}
PerfectCasino.Translation.Config.combo.Title = "Настройки комбинаций"
PerfectCasino.Translation.Config.combo.Desc = "Создавайте комбинации для выплат"

PerfectCasino.Translation.Config.wheel = {}
PerfectCasino.Translation.Config.wheel.Title = "Настройки колеса"
PerfectCasino.Translation.Config.wheel.Desc = "Установите, какие награды выдаются на колесе"

PerfectCasino.Translation.Config.bet = {}
PerfectCasino.Translation.Config.bet.Title = "Настройки ставок"
PerfectCasino.Translation.Config.bet.Desc = "Установите лимиты ставок"
PerfectCasino.Translation.Config.bet.default = "Значение ставки по умолчанию"
PerfectCasino.Translation.Config.bet.max = "Максимальное значение ставки"
PerfectCasino.Translation.Config.bet.min = "Минимальное значение ставки"
PerfectCasino.Translation.Config.bet.iteration = "Увеличение ставки при нажатии на стрелку"
PerfectCasino.Translation.Config.bet.betLimit = "Максимальная ставка за раунд на игрока (0 = без лимита)"

PerfectCasino.Translation.Config.chance = {}
PerfectCasino.Translation.Config.chance.Title = "Настройки шансов"
PerfectCasino.Translation.Config.chance.Desc = "Установите шансы выпадения этого предмета. Больше значение = больше шанс"
PerfectCasino.Translation.Config.chance.Bar = "Визуализация шансов"

PerfectCasino.Translation.Config.other = {}
PerfectCasino.Translation.Config.other.Title = "Другие настройки"
PerfectCasino.Translation.Config.other.Desc = "Разные настройки"

PerfectCasino.Translation.Config.turn = {}
PerfectCasino.Translation.Config.turn.Title = "Настройки хода"
PerfectCasino.Translation.Config.turn.Desc = "Настройки для каждого хода"
PerfectCasino.Translation.Config.turn.timeout = "Количество секунд до таймаута хода"

PerfectCasino.Translation.Config.payout = {}
PerfectCasino.Translation.Config.payout.Title = "Настройки выплат"
PerfectCasino.Translation.Config.payout.Desc = "Настройки выплат"
PerfectCasino.Translation.Config.payout.win = "Множитель выплаты за победу"

PerfectCasino.Translation.Config.text = {}
PerfectCasino.Translation.Config.text.Title = "Настройки текста"
PerfectCasino.Translation.Config.text.Desc = "Настройки текста"
PerfectCasino.Translation.Config.text.overhead = "Текст, отображаемый над НПС"
PerfectCasino.Translation.Config.text.chat = "Сообщение в чат при взаимодействии"

-- Инструмент
PerfectCasino.Translation.ToolGun = {}
PerfectCasino.Translation.ToolGun.NoEntity = "Сначала настройте сущность с помощью ПКМ"
PerfectCasino.Translation.ToolGun.DeletePermissions = "FPP БЛОКИРУЕТ РАЗРЕШЕНИЯ ВАШЕГО PCASINO ИНСТРУМЕНТА"
PerfectCasino.Translation.ToolGun.FPPCheck = "Проверьте, можете ли вы использовать инструмент на этой сущности с помощью FPP!"

-- Интерфейсы сущностей
PerfectCasino.Translation.UI = {}
PerfectCasino.Translation.UI.JackPot = "Джекпот: %s"
PerfectCasino.Translation.UI.Number = "Число: %i"
PerfectCasino.Translation.UI.Start = "Старт: %is"
PerfectCasino.Translation.UI.PlaceBet = "Сделать ставку"
PerfectCasino.Translation.UI.Waiting = "Ожидание"
PerfectCasino.Translation.UI.DoubleDown = "Удвоить"
PerfectCasino.Translation.UI.Split = "Разделить"
PerfectCasino.Translation.UI.Hit = "Взять карту"
PerfectCasino.Translation.UI.Stand = "Остановиться"
PerfectCasino.Translation.UI.Blackjack = "%i (Блэкджек)"
PerfectCasino.Translation.UI.Bust = "%i (Перебор)"
PerfectCasino.Translation.UI.CurrentHandTotalValue = "Стоимость руки: %s"
PerfectCasino.Translation.UI.CurrentHand = "Текущая рука: %s"
PerfectCasino.Translation.UI.SpinThatWheel = "Крути колесо!"
PerfectCasino.Translation.UI.ReadyToPlay = "Готов к игре!"
PerfectCasino.Translation.UI.PurchaseASpin = "Купить вращение!"
PerfectCasino.Translation.UI.FreeSpin = "Бесплатное вращение!"
PerfectCasino.Translation.UI.FreeSpinCount = "Бесплатных вращений: %s"
PerfectCasino.Translation.UI.Play = "Играть: %s"
PerfectCasino.Translation.UI.LeaveSeat = "Зажмите E, чтобы выйти из-за стола"
PerfectCasino.Translation.UI.BetLimit = "Лимит ставки: %s"

-- Сообщения в чате
PerfectCasino.Translation.Chat = {}
PerfectCasino.Translation.Chat.NoMoney = "У вас недостаточно денег, чтобы сделать эту ставку..."
PerfectCasino.Translation.Chat.Payout = "Вы выиграли %s!"
PerfectCasino.Translation.Chat.RouletteFail = "Ни одна из ваших ставок не сыграла..."
PerfectCasino.Translation.Chat.PayoutJackpot = "Вы сорвали джекпот в размере %s!"
PerfectCasino.Translation.Chat.AlreadyPlaced = "Вы уже сделали ставку..."
PerfectCasino.Translation.Chat.BetPlaced = "Ваша ставка принята!"
PerfectCasino.Translation.Chat.HandBust = "У вас перебор, вы не получите выплату..."
PerfectCasino.Translation.Chat.DealerHandBust = "У дилера перебор, ваша выплата составляет %s!"
PerfectCasino.Translation.Chat.HandDraw = "Ничья с казино, ваша ставка возвращена."
PerfectCasino.Translation.Chat.HandLose = "Рука казино бьёт вашу руку, вы не получите выплату..."
PerfectCasino.Translation.Chat.HandWin = "Вы обыграли казино, ваша выплата составляет %s!"
PerfectCasino.Translation.Chat.SlotWheelSpin = "Вы крутанули колесо и получили %s!"
PerfectCasino.Translation.Chat.UsedFreeSpin = "Вы использовали бесплатное вращение!"
PerfectCasino.Translation.Chat.UsedPaidSpin = "Вы заплатили %s за вращение!"
PerfectCasino.Translation.Chat.BetLimit = "Вы достигли лимита ставок для этого раунда!"
PerfectCasino.Translation.Chat.WillReachBetLimit = "Эта ставка превысит лимит. Вы не можете поставить больше %s..."
PerfectCasino.Translation.Chat.LimitMachineUse = "Вы пытаетесь использовать другой автомат слишком быстро..."
PerfectCasino.Translation.Chat.LimitMachineUsedByOther = "Этот автомат сейчас использует кто-то другой!"


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher