import {
  Button,
  Row, Col,
  Table
} from "reactstrap";

import avatar from "../../assets/img/default-avatar.png";

const IntroProfile = () => {

  const badges = [
    { id: 1, point: 200, name: "Badge 1", description: "This is the first badge", date: "16/01/2020", color: "info" },
    { id: 2, point: 300, name: "Badge 2", description: "This is the second badge", date: "16/01/2020", color: "warning" },
    { id: 3, point: 400, name: "Badge 3", description: "This is the third badge", date: "16/01/2020", color: "danger" },
    { id: 4, point: 500, name: "Badge 4", description: "This is the fourth badge", date: "16/01/2020", color: "primary" },
  ]

  const setColor = (color) => {
    switch (color) {
      case 'primary':
        return 'text-primary';
      case 'info':
        return 'text-info';
      case 'warning':
        return 'text-warning';
      case 'danger':
        return 'text-danger';
      default:
        return 'text-primary';
    }
  }


  return (
    <section className='w-100 px-3'>
      <h4>Intro</h4>
      <Row className='w-100 d-flex justify-content-around'>
        {/* <Col md="3" className=' card m-2 p-3 d-flex justify-content-center'>
          <div className='d-flex flex-column'>
            <img src={avatar} alt="..." className="img-circle img-no-padding img-responsive" />
            <Button color="primary">Download .pdf</Button>
          </div>
        </Col> */}
        <Col md="12" className='m-2 p-3'>
          <Row>
            <Col sm="6">
              Full Name: John Doe
            </Col>
            <Col sm="6">
              Date of Birth: 05/08/1999
            </Col>
            <Col sm="6">
              Gender: Male
            </Col>
            <Col sm="6">
              Address: American
            </Col>
          </Row>
        </Col>
      </Row>
      <hr />
      <h4>Following</h4>
      <Row className='w-100 d-flex justify-content-around'>
        <Col md="3" className=' card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col md="7" xs="7">
              DJ Khaled <br />
              <span className="text-muted">
                <small>Offline</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>

        <Col md="3" className=' card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col md="7" xs="7">
              Creative Tim <br />
              <span className="text-success">
                <small>Available</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>
        <Col md="3" className='card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col className="col-ms-7" xs="7">
              Flume <br />
              <span className="text-danger">
                <small>Busy</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>
      </Row>
      <a className="btn btn-default btn-link ml-auto me-0" href="#">View all</a>
      <hr />
      <h4>Followed:</h4>
      <Row className='w-100 d-flex justify-content-around'>
        <Col md="3" className=' card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col md="7" xs="7">
              DJ Khaled <br />
              <span className="text-muted">
                <small>Offline</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>

        <Col md="3" className=' card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col md="7" xs="7">
              Creative Tim <br />
              <span className="text-success">
                <small>Available</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>
        <Col md="3" className='card m-2 p-3 d-flex justify-content-center'>
          <Row>
            <Col md="2" xs="2">
              <div className="avatar">
                <img
                  alt="..."
                  className="img-circle img-no-padding img-responsive"
                  src={avatar}
                />
              </div>
            </Col>
            <Col className="col-ms-7" xs="7">
              Flume <br />
              <span className="text-danger">
                <small>Busy</small>
              </span>
            </Col>
            <Col className="text-right" md="3" xs="3">
              <Button
                className="btn-round btn-icon"
                color="success"
                outline
                size="sm"
              >
                <i className="fa fa-envelope" />
              </Button>
            </Col>
          </Row>
        </Col>
      </Row>
      <a className="btn btn-default btn-link ml-auto me-0" href="#">View all</a>
      <hr />
      <h4>Badges</h4>
      <div className="px-md-3">
        <Table responsive>
          <tbody>
            {badges.map((item) => (
              <tr key={item.id}>
                <td>
                  <h6 className={setColor(item?.color)}>
                    {item?.point}
                  </h6>
                </td>
                <td>
                  <div className={setColor(item?.color)}>
                    <h6>{item?.name}</h6> {item?.description}
                  </div>
                </td>
                <td className={"td-actions " + setColor(item.color)}>
                  {item?.date}
                </td>
              </tr>
            ))}

          </tbody>
        </Table>
      </div>


    </section>
  )
}

export default IntroProfile;