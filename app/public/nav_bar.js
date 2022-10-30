const template = document.createElement('template');
template.innerHTML = `
    <nav>
        <a href='/'>Home</a>
        <a href='/champions'>Champions</a>
        <a href='/matches'>Matches</a>
        <a href='/summoners'>Summoners</a>
        <a href='/db_overview'>Database Overview</a>
    </nav>
`;
document.body.appendChild(template.content);