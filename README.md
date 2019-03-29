# watchmans
mans who can watch)

# Examples:

create Hook-Hook-Hoook!

curl -XGET -H "Content-type: application/json" -d '{"customer": {"video_id": 1}}' 'localhost:3000/customers'

create some customers by video_id(that being watching right now, yap!) 

curl -XGET -H "Content-type: application/json" -d '{"customer": {"video_id": 1}}' 'localhost:3000/customers'

# INFO

 --- Принимает от клиентов уведомления о том, что клиент смотрит видео.

  -- Это у нас тут - customers/is_watching_now

 --- Отвечает на запрос, сколько видео потоков смотрит пользователь в данный момент.

  -- Это тутама - customers/index, video_id

 --- Отвечает на вопрос, сколько пользователей смотрят данное видео.  
 
  -- Это тутама - video/current_watchmans