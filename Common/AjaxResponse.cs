using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{
    public class AjaxResponse
    {
        public string Message { get; set; }
        public StatusCode StatusCode { get; set; }
        public object Data { get; set; }
        public string Location { get; set; }
    }
}
