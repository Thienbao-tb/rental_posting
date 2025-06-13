<!-- @extends('frontend.layouts.app_master') -->
<!-- @section('title', 'Login') -->


<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.css" rel="stylesheet" />
<!------ Include the above in your HEAD tag ---------->
<style>
.main {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
.login-form {
    width: 600px;
    height: 342px;
    padding: 20px;
    box-shadow: rgba(50, 50, 105, 0.15) 0px 2px 5px 0px, rgba(0, 0, 0, 0.05) 0px 1px 1px 0px;
}
.btn {
  border: 1px solid transparent;
  border-radius: 5px;
  cursor: pointer;
  display: inline-block;
  font-size: 14px;
  font-weight: 400;
  letter-spacing: 0.3px;
  line-height: 20px;
  padding: 0.45rem 0.95rem;
  text-align: center;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  vertical-align: middle;
  white-space: nowrap;
  color: white;
  font-weight: bold;
}

</style>
<div class="main">
    <div class="login-form">
            <form method="POST" action="" autocomplete="off">
                @csrf
                <h2 style="text-align: center;">ADMIN</h2>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required class="form-control" placeholder="Email">
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required class="form-control" placeholder="Password">
                </div>
                <button type="submit" class="btn" onclick="check()"
                    style="background-color: #0a8066; width:100%">Login
                </button>
            </form>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<script>
        toastr.options.positionClass = 'toastr-bottom-right';
</script>