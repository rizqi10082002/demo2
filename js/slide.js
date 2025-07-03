const swiper = new Swiper('.main-swiper', {
    loop: true,
    autoplay: {
      delay: 3000, // delay 3 detik
      disableOnInteraction: false
    },
    speed: 800, // kecepatan transisi
    pagination: {
      el: '.swiper-pagination',
      clickable: true
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev'
    }
  });