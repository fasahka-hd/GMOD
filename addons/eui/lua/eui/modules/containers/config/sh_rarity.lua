local container = eui.container
if SERVER then return end

container.rarity = {
    ['Обычный'] = {
        eui.Color('A8A8A8'), 
        eui.Color('C0C0C0')  
    },
    ['Редкий'] = {
        eui.Color('3399FF'), 
        eui.Color('0066FF')  
    },
    ['Эпический'] = {
        eui.Color('9933FF'),  
        eui.Color('6600CC')  
    },
    ['Мифический'] = {
        eui.Color('FF33CC'), 
        eui.Color('FF0099')  
    },
    ['Легендарный'] = {
        eui.Color('FF9933'),  
        eui.Color('FF6600')  
    },
    ['Неизвестный'] = {
        eui.Color('FF0000'), 
        eui.Color('990000')  
    },
}

