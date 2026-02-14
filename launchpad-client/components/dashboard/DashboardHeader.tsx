import { Typography, Divider } from "@mui/material";

import { WebStories, Loop, Grading, CheckBox, DirectionsRun, Scoreboard } from "@mui/icons-material";

const DashboardHeader = () => {
    return (
        <div className="">
            <div className="w-full flex items-center justify-between">
                <h2 className="text-white w-1/6 text-center font-bold text-2xl bg-blue-500/70 rounded-md p-4 flex items-center justify-between">
                    <WebStories/>
                    1
                </h2>
                <h2 className="text-white w-1/6 text-center font-bold text-2xl bg-orange-400/70 rounded-md p-4 flex items-center justify-between">
                    <Loop/>
                    4
                </h2>
                <h2 className="text-white w-1/6 text-center font-bold text-2xl bg-yellow-400/70 rounded-md p-4 flex items-center justify-between">
                    <Grading/>
                    0
                </h2>
                <h2 className="text-white w-1/6 text-center font-bold text-2xl bg-green-500/70 rounded-md p-4 flex items-center justify-between">
                <CheckBox/>
                    8
                </h2>
            </div>
            <Divider className="my-4 bg-(--purple) h-0.5"/>
            <div className="flex justify-between bg-(--purple) rounded-md">
                <div className="flex text-white p-2">
                    <DirectionsRun className="mr-2"/>
                    <h2 className="font-bold text-white">CURRENT SPRINT</h2>
                </div>
                <h2 className="flex items-center justify-center text-white p-2 font-bold">
                    <Scoreboard className="text-white mr-2"/>
                    12
                </h2>
            </div>
        </div>
    );
}
 
export default DashboardHeader;