using CORE.Tables;
using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using WebAdmin.Helpers;
using WebAdmin.Models;

namespace WebAdmin.Controllers
{
    public class AjaxController : BaseController
    {
        public JsonResult FileUpload(HttpPostedFileBase file)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                string folderPath = "";// Configuration.AppConfigInfo.;
                string filePath = "";
                if (file != null)
                {
                    var fileName = Path.GetFileName(file.FileName);
                    var extention = Path.GetExtension(file.FileName);
                    var filenamewithoutextension = Path.GetFileNameWithoutExtension(file.FileName);
                    if (!folderPath.EndsWith("/"))
                        filePath += "/" + DateTime.Now.ToString("yyyy_MM_dd") + "/";
                    else
                        filePath += DateTime.Now.ToString("yyyy_MM_dd") + "/";
                    IOHelper.CreateFolder(folderPath + filePath);
                    file.SaveAs(folderPath + filePath + file.FileName);

                    Result.Result = filePath + file.FileName;
                }

                Result.Code = 0;
            }
            catch
            {
                Result.Code = 2000;
                Result.Result = "Ajax Error From Server";
            }

            return Json(new JsonResult() { Data = Result });
        }

        #region Upload Photo

        public byte[] GetUploadedPhoto(FileUpload File)
        {
            using (Stream PhotoStream = File.PostedFile.InputStream)
            {
                long photoStreamLength = PhotoStream.Length;
                byte[] photoBytes = new byte[photoStreamLength + 1];
                PhotoStream.Read(photoBytes, 0, (int)photoStreamLength);
                return photoBytes;
            }
        }

        #endregion

        public JsonResult InsertBlog(string blog_name, string blog_content, string blog_type)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                if (Blogs_Service.Insert(new TB_BLOGS
                {
                    BlogName = blog_name,
                    BlogContent = blog_content,
                    BlogType = blog_type,
                    BlogDateCreate = DateTime.Now,
                    BlogIsShow = true,
                    BlogUserId = UserId
                }))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }

        public JsonResult UpdateBlog(int blog_id, string blog_name, string blog_content, string blog_type)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                TB_BLOGS blog = Blogs_Service.GetById(blog_id);
                blog.BlogName = blog_name;
                blog.BlogContent = blog_content;
                blog.BlogType = blog_type;
                blog.BlogUserId = UserId;

                if (Blogs_Service.Update(blog))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }

        public JsonResult InsertSerivceType(string type_code, string type_name)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                if (Types_Service.Insert(new TB_TYPES
                {
                    TypeCode = type_code,
                    TypeName = type_name
                }))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }

        public JsonResult UpdateSerivceType(string type_code, string type_name)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                TB_TYPES t = Types_Service.GetById(type_code);
                t.TypeCode = type_code;
                t.TypeName = type_name;

                if (Types_Service.Update(t))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }

        public JsonResult InsertSerivce(string service_name, decimal service_price, string service_unit, string service_base, string service_content, string service_type)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                if (Services_Service.Insert(new TB_SERVICES
                {
                    ServiceName = service_name,
                    ServicePrice = service_price,
                    ServiceUnit = service_unit,
                    ServiceBase = service_base,
                    ServiceContent = service_content,
                    ServiceTypeCode = service_type
                }))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }

        public JsonResult UpdateSerivce(int service_id, string service_name, decimal service_price, string service_unit, string service_base, string service_content, string service_type)
        {
            AjaxResultModel Result = new AjaxResultModel();

            try
            {
                TB_SERVICES t = Services_Service.GetById(service_id);
                t.ServiceName = service_name;
                t.ServicePrice = service_price;
                t.ServiceUnit = service_unit;
                t.ServiceBase = service_base;
                t.ServiceContent = service_content;
                t.ServiceTypeCode = service_type;

                if (Services_Service.Update(t))
                {
                    Result.Code = 000;
                    Result.Result = "Thành công";
                }
                else
                {
                    Result.Code = 001;
                    Result.Result = "Không thành công";
                }
            }
            catch (Exception Ex)
            {
                Result.Code = 2000;
                Result.Result = "Có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với người quản trị.";
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "UpdatePassword :", Ex.Message, Ex.ToString());
            }

            return Json(Result);
        }
    }
}