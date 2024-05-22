
// set param url
export function pathParams(data) {
  let params = new URLSearchParams();
  Object.keys(data).forEach(key => {
    data[key] && params.append(key, data[key]);
  })
  return params;
}

//convert name role;
export function convertNameRole(role) {
  let name = "";
  switch (role) {
    case "ROLE_ADMIN":
      name = "Admin";
      break;
    case "ROLE_USER":
      name = "User";
      break;
    case "ROLE_MODERATOR":
      name = "Moderator";
      break;
    default:
      break;
  }
  return name;
}


//convert list name role
export function convertListNameRole(roles) {
  let names = '';
  roles.forEach(role => {
    names += convertNameRole(role) + ", ";
  });
  names = names.slice(0, -2);
  return names;
}