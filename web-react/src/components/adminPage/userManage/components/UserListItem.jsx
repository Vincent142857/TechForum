import PropTypes from 'prop-types';
import Avatar from '../../../avatar/Avatar';
import { Link } from 'react-router-dom';
import { convertListNameRole } from '../../../../utils/Helper';

const UserListItem = (props) => {
  const { user, handleShowHideEdit, handleSetEditUser, handleShowHide, handleSetDeleteUser } = props;

  const handleDelete = () => {
    handleSetDeleteUser(user);
    handleShowHide();
  }

  const handleUpdate = () => {
    handleSetEditUser(user);
    handleShowHideEdit();
  }


  return (
    <tr key={user.id}>
      <td>
        <div className='ml-0 me-auto'>
          <Avatar src={user?.imageUrl} username={user?.username} height={50} width={50} />
        </div>
      </td>
      <td>
        <Link to={`/admin/member-profile/${user?.username}`} state={{ user }}>
          <p>{user.email}</p>
        </Link>
      </td>
      <td>
        {convertListNameRole(user.roles.map(x => x.name))}
      </td>
      <td>
        <i className="fas fa-sync-alt mx-2"
          onClick={handleUpdate}
        ></i>
        {user.accountStatus}
      </td>
      <td>
        <div className='d-flex justify-content-center'>
          <button className="btn btn-danger mx-2"
            onClick={() => { handleDelete() }}>
            <i className="fa-solid fa-delete-left"></i>
          </button>
        </div>
      </td>
    </tr>


  );
}


UserListItem.propTypes = {
  user: PropTypes.object.isRequired,
  handleShowHideEdit: PropTypes.func.isRequired,
  handleSetEditUser: PropTypes.func.isRequired,
  handleShowHide: PropTypes.func.isRequired,
  handleSetDeleteUser: PropTypes.func.isRequired
};

export default UserListItem;