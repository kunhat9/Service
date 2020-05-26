using CORE.Tables;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace WebClient.Controllers
{
    public class ServicesController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult _List(string keyText = "", int pageNumber = 1, int pageSize = 10)
        {
            List<TB_SERVICES> list = new List<TB_SERVICES>();

            int count = 0;
            try
            {
                list = Services_Service.GetAll();
            }
            catch (Exception ex)
            {
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "Services/_List :", ex.Message, ex.ToString());
            }

            ViewBag.maxNumber = Math.Ceiling((double)count / pageSize);
            ViewBag.pageNumber = pageNumber;
            ViewBag.pageSize = pageSize;

            return PartialView(list);
        }

        public PartialViewResult _ListDetail(int serviceId = 0)
        {
            int height = (int)(Request.Browser.ScreenPixelsHeight * 0.85);

            TB_SERVICES s = Services_Service.GetById(serviceId);
            ViewBag.Service = s;

            return PartialView(height);
        }

        public ActionResult TypeList()
        {
            return View();
        }

        public PartialViewResult _TypeList(string keyText = "", int pageNumber = 1, int pageSize = 10)
        {
            List<TB_TYPES> list = new List<TB_TYPES>();

            int count = 0;
            try
            {
                list = Types_Service.GetAll();
            }
            catch (Exception ex)
            {
                CORE.Helpers.IOHelper.WriteLog(StartUpPath, IpAddress, "Services/_TypeList :", ex.Message, ex.ToString());
            }

            ViewBag.maxNumber = Math.Ceiling((double)count / pageSize);
            ViewBag.pageNumber = pageNumber;
            ViewBag.pageSize = pageSize;

            return PartialView(list);
        }

        public PartialViewResult _TypeListDetail(string typeCode = "")
        {
            int height = (int)(Request.Browser.ScreenPixelsHeight * 0.85);

            TB_TYPES type = Types_Service.GetById(typeCode);
            ViewBag.ServiceType = type;

            return PartialView(height);
        }

        public ActionResult Detail(string Id = "")
        {
            List<TB_SERVICES> list = Services_Service.GetAll()
                .Where(x => x.ServiceTypeCode == Id)
                .OrderBy(x => x.ServiceId)
                .ToList();

            return View(list);
        }
    }
}