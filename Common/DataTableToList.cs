using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Text;

namespace Common
{
    public class DataTableToList
    {
        public static List<T> List<T>(DataTable dt)
        {
            var list = new List<T>();
            Type t = typeof(T);
            var plist = new List<PropertyInfo>(typeof(T).GetProperties());
            foreach (DataRow item in dt.Rows)
            {
                T s = System.Activator.CreateInstance<T>();
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    PropertyInfo info = plist.Find(p => p.Name.ToLower() == dt.Columns[i].ColumnName.ToLower());
                    if (info != null)
                    {
                        if (!Convert.IsDBNull(item[i]))
                        {
                            if (info.PropertyType.IsEnum)
                            {
                                int intEnum;
                                if (Int32.TryParse(item[i].ToString(), out intEnum))
                                {
                                    info.SetValue(s, Convert.ToInt32(item[i]), null);
                                }
                            }
                            else if (info.PropertyType == typeof(decimal))
                            {
                                info.SetValue(s, Convert.ToDecimal(item[i]), null);
                            }
                            else if(info.PropertyType==typeof(string))
                            {
                                info.SetValue(s, item[i].ToString().Trim(), null);
                            }
                            else
                            {
                                info.SetValue(s, item[i], null);
                            }
                        }
                    }
                }
                list.Add(s);
            }
            return list;
        }
    }
}
