import {
  Button, Modal
} from 'react-bootstrap';
import {
  Form, FormGroup, Label, Input
} from 'reactstrap';
import PropTypes from 'prop-types';
import { ACCOUNT_STATUS } from "../../../../constants/index";
import { useState } from 'react';


const ModalEditUser = (props) => {

  const { show, handleClose, handleUpdateStatus, user } = props;

  const [status, setStatus] = useState(user.accountStatus);

  const handleEditStatus = () => {
    console.log(`Status`, status);
    handleUpdateStatus(user.id, status);
  }


  return (
    <Modal show={show} onHide={handleClose}
      backdrop="static"
      size="md"
      keyboard={false}>

      <Modal.Header closeButton>
        <Modal.Title className='text-primary'><i className="fa-solid fa-pen-to-square"></i> Edit user {user?.username}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <Form>
          <FormGroup>
            Username: {user.username}
          </FormGroup>
          <FormGroup>
            Email: {user.email}
          </FormGroup>
          <FormGroup>
            <Label for="accountStatus">Account Status:</Label>
            <Input type="select" name="accountStatus" id="accountStatus"
              onChange={(e) => setStatus(e.target.value)} value={status}>
              <option value={ACCOUNT_STATUS.INACTIVE}>InActive</option>
              <option value={ACCOUNT_STATUS.ACTIVE}>Active</option>
              <option value={ACCOUNT_STATUS.LOCKED}>LOCKED</option>
            </Input>
          </FormGroup>
        </Form>
      </Modal.Body>

      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>Close</Button>
        <Button variant="primary" onClick={handleEditStatus}>Save Changes</Button>
      </Modal.Footer>
    </Modal>
  )
}

ModalEditUser.propTypes = {
  show: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
  handleUpdateStatus: PropTypes.func.isRequired,
  user: PropTypes.object.isRequired,
};

export default ModalEditUser;