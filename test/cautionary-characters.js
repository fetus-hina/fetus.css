jQuery($ => {
  const list = [
    // 5c or yen
    [
      ['\u005c', 'Backslash'],
      ['\u00a5', 'Yen Sign'],
      ['\uffe5', 'Fullwidth Yen'],
      ['\uff3c', 'Fullwidth BS'],
    ],
    // wave dash vs fullwidth tilde
    [
      ['\u301c', 'Wave Dash'],
      ['\uff5e', 'Fullwidth Tilde'],
    ],
  ];

  $('.cautionary-characters').each(function () {
    const $container = $(this);
    list.forEach(chars => {
      $container.append(formatTable(chars));
    });
  });

  function formatTable (chars) {
    const $tbody = $('<tbody>');
    chars.forEach(([c, name]) => {
      $tbody.append($('<tr>')
        .append($('<th scope="row">').text('U+' + c.codePointAt(0).toString(16).toUpperCase()))
        .append($('<td>').text(c))
        .append($('<td class="meiryo">').text(c))
        .append($('<td>').text(name))
      );
    });

    return $('<div class="col-lg-4">').append(
      $('<table class="table">')
        .append(
          $('<thead><tr><th>Codepoint</th><th>Char</th><th>Meiryo</th><th>Name</th></tr></thead>')
        )
        .append($tbody)
    );
  }
});
