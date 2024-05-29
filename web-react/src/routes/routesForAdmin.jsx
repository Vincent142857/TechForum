import DashBoard from "../components/adminPage/adminDashBoard/DashBoardPage"
import DiscussionManage from "../components/adminPage/discussionManage/DiscussionManage";
import ForumManage from "../components/adminPage/forumManage/ForumManage";
import TagsStat from "../components/adminPage/tagManage/TagsStat";
import TableUsers from "../components/adminPage/userManage/UsersListManagePage"
import ViewDiscussion from "../components/discussions/ViewDiscussion";

import EmailOption from "../components/adminPage/emailOptionManage/EmailOptionPage";

const routes = [
  {
    path: "/dashboard",
    name: "dashboard",
    icon: "fa-solid fa-building-columns",
    component: <DashBoard />,
    layout: "/admin"
  },
  {
    path: "/users",
    name: "manage users",
    icon: "fa-solid fa-people-group",
    component: <TableUsers />,
    layout: "/admin"
  },
  {
    path: "/forums",
    name: "manage forums",
    icon: "fa-solid fa-users",
    component: <ForumManage />,
    layout: "/admin"
  },
  {
    path: "/discussions",
    name: "manage discussions",
    icon: "fa-solid fa-comments",
    component: <DiscussionManage />,
    layout: "/admin"
  },
  {
    path: "/comments",
    name: "manage comments",
    icon: "fa-solid fa-comment",
    component: <ViewDiscussion />,
    layout: "/admin"
  },
  {
    path: "/tags",
    name: "manage tags",
    icon: "fa-solid fa-tags",
    component: <TagsStat />,
    layout: "/admin"
  },
  {
    path: "/email-option",
    name: "Config email",
    icon: "fa-solid fa-envelope",
    component: <EmailOption />,
    layout: "/admin"
  }
];


export default routes;