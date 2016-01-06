(function(xhr) {
  function attachCSRF(xhrInstance) {
    var token = $('meta[name="csrf-token"]').attr('content');
    console.log(token);
    if (token) {
      xhrInstance.setRequestHeader('X-CSRF-Token', token);
    }
  }
  var send = xhr.send
  xhr.send = function(data) {
    var rsc = this.onreadystatechange;
    if (rsc) {
      this.onreadystatechange = function() {
        attachCSRF(this);
        return rsc.apply(this, arguments);
      };
    }
    return send.apply(this, arguments);
  };
})(XMLHttpRequest.prototype);
