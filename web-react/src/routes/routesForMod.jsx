import DashBoard from "../components/adminPage/adminDashBoard/DashBoardPage";
import DiscussionManage from "../components/adminPage/discussionManage/DiscussionManage";
import TagsStat from "../components/adminPage/tagManage/TagsManage";


const routesForMod = [
	{
		path: "/dashboard",
		name: "dashboard",
		icon: "fa-solid fa-building-columns",
		component: <DashBoard />,
		layout: "/admin",
	},
	{
		path: "/discussions",
		name: "discussions manage",
		icon: "fa-solid fa-comments",
		component: <DiscussionManage />,
		layout: "/admin",
	},
	{
		path: "/tags",
		name: "tags manage",
		icon: "fa-solid fa-tags",
		component: <TagsStat />,
		layout: "/admin",
	},
];

export default routesForMod;
