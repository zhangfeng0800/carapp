using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web.UI.WebControls.WebParts;

namespace Common
{
    public class PostHelper
    {
        public static void GetModel<T>(ref T model, NameValueCollection requestDate)
        {
            Type type = model.GetType();
            PropertyInfo[] propertyInfos = type.GetProperties();
            foreach (var p in propertyInfos)
            {
                var value = requestDate[p.Name.ToLower()];
                if (value == null)
                {
                    continue;
                }
                if (!p.PropertyType.IsGenericType)
                {
                    try
                    {
                        p.SetValue(model, Convert.ChangeType(value, p.PropertyType), null);
                    }
                    catch
                    {

                    }
                }
                else
                {
                    Type genericTypeDefinition = p.PropertyType.GetGenericTypeDefinition();
                    if (genericTypeDefinition == typeof (Nullable<>))
                    {
                        try
                        {
                            p.SetValue(model,
                                string.IsNullOrEmpty(value)
                                    ? null
                                    : Convert.ChangeType(value, Nullable.GetUnderlyingType(p.PropertyType)), null);
                        }
                        catch
                        {
                            
                        } 
                    }
                }
            }
        }
    }
}
