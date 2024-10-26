document.addEventListener("turbo:load", () => {
    const passwordField = document.getElementById('passwordField');
    const showPasswordCheckbox = document.getElementById('showPasswordCheckbox');

    if (showPasswordCheckbox) {
      showPasswordCheckbox.addEventListener('change', function() {
        passwordField.type = this.checked ? 'text' : 'password';
      });
    }
});
