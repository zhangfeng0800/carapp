using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{
    public class AirportEntity
    {
        public int code { get; set; }
        public object result { get; set; }
        public int time { get; set; }
    }

    public class AirplaneInfo
    {
        public string active { get; set; }
        public object airport_info { get; set; }
        public string arr { get; set; }
        public string arr_city { get; set; }
        public string arr_code { get; set; }
        public string arr_t { get; set; }
        public string arr_time { get; set; }
        public string company { get; set; }
        public string dep { get; set; }
        /// <summary>
        /// 获取出发机场的信息
        /// </summary>
        public object dep_airport_info { get; set; }
        public string dep_city { get; set; }
        public string dep_code { get; set; }
        public string dep_date { get; set; }
        public string dep_t { get; set; }
        public string dep_time { get; set; }
        public string flag { get; set; }
        public string flight_number { get; set; }
        public int id { get; set; }
        public int service_time { get; set; }
        public string source { get; set; }
        public string state { get; set; }
        public string state_text { get; set; }
    }
    public class DepatureAirportInfo
    {
        public string city { get; set; }
        public string flag { get; set; }
        public string name { get; set; }
        public Position position { get; set; }
    }

    public class Position
    {
        public string lng { get; set; }
        public string lat { get; set; }
    }
}
