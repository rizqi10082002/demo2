function login() {
    const validUsername = "admin";
    const validPassword = "12345";

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    if (username === validUsername && password === validPassword) {
        // Tutup modal terlebih dahulu
        var modalEl = document.getElementById('exampleModal');
        var modal = bootstrap.Modal.getInstance(modalEl);
        modal.hide();

        // Tampilkan SweetAlert setelah sedikit delay
        setTimeout(() => {
            Swal.fire({
                title: "Sukses!",
                text: "Login berhasil.",
                icon: "success"
            });
        }, 300);
    } else {
     // Tutup modal terlebih dahulu
     var modalEl = document.getElementById('exampleModal');
     var modal = bootstrap.Modal.getInstance(modalEl);
     modal.hide();

     // Tampilkan SweetAlert setelah sedikit delay
     setTimeout(() => {
         Swal.fire({
             title: "Gagal",
             text: "Login tidak berhasil.",
             icon: "error"
         });
     }, 300);
    }
}
