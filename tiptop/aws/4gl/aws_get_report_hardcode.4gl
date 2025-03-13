# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_report_hardcode.4gl
# Descriptions...: 報表 HardCode 程式
# Date & Author..: 2009/05/04 Echo
# Memo...........:
# Modify.........: No.FUN-930132 新建立
#
#}
 
DATABASE ds
 
#No.FUN-930132
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
FUNCTION aws_get_report_hardcode(p_ReportID)
DEFINE p_ReportID   STRING
DEFINE l_str        STRING
 
   #依照報表ID, 以 XML 字串格式指定參數預設值
   CASE p_ReportID
      WHEN "axmr411"  
           LET l_str = "<tm.yy>", YEAR(TODAY)    ,"</tm.yy>",
                       "<tm.mm>", MONTH(TODAY)-2 ,"</tm.mm>"
 
      WHEN "apmr001"
           LET l_str = "<tm.bdate>", TODAY-30 ,"</tm.bdate>"
 
      WHEN "apmr710"
           LET l_str = "<tm.vdate>", TODAY+7 ,"</tm.vdate>"
 
      WHEN "axmr212"
           LET l_str = "<tm.date>", TODAY+30 ,"</tm.date>"
 
      #新增的報表ID 請在此增加
      #......                   
   END CASE
 
   RETURN l_str
END FUNCTION
 
