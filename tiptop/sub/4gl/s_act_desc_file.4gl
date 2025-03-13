# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_act_desc_file.4gl
# Descriptions...: Action 說明轉換為依語言別顯示 (資料來源  各語言4ad檔)
# Date & Author..: 03/11/25 by Hiko
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   mc_default_action  LIKE zy_file.zy03,
         mc_return_act      LIKE zy_file.zy03
DEFINE   ma_act             DYNAMIC ARRAY OF RECORD
         act_name           STRING,
         act_desc           STRING
                            END RECORD 
 
# Descriptions...: 
 
FUNCTION s_act_desc_file(pc_default_action)
 
   DEFINE   pc_default_action  LIKE zy_file.zy03
   DEFINE   pc_show_method     LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET mc_default_action = DOWNSHIFT(pc_default_action)
   LET mc_return_act = ""
   LET pc_show_method= "Y"
 
   CALL s_act_desc_file_set_data()
   CALL s_act_desc_file_get_set(pc_show_method) RETURNING mc_return_act
 
   RETURN mc_return_act
END FUNCTION
 
# Descriptions...: 抓取 4ad 設定比對陣列中的原始資料
# Input Parameter: none
# Return Code....: void
 
FUNCTION s_act_desc_file_set_data()
 
   DEFINE   li_i          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            lxml_reader   om.XmlReader,
            ls_data       STRING,
            lsax_attrib   om.SaxAttributes,
            li_index      LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            ls_name       STRING
 
   CALL ma_act.clear()
 
   LET li_index = 0
 
   CALL cl_set_act_lang(g_lang)
   LET lxml_reader = om.XmlReader.createFileReader(cl_get_act_path(g_prog))
   LET lsax_attrib = lxml_reader.getAttributes()
   LET ls_data = lxml_reader.read()
   WHILE ls_data IS NOT NULL
      CASE ls_data
         WHEN "StartElement"
            LET ls_name = lsax_attrib.getValue("name")
            IF (NOT cl_null(ls_name)) THEN
 
               LET ls_name = ls_name.trim()
               LET ma_act[li_index+1].act_name = ls_name
               LET ma_act[li_index+1].act_desc = lsax_attrib.getValue("text")
               LET li_index = li_index + 1
 
            END IF
      END CASE
 
      LET ls_data = lxml_reader.read()
   END WHILE
 
   CALL cl_act_del_tmp_path()
 
END FUNCTION
 
 
# Descriptions...: 抓取傳入值並與資料陣列做比對
# Input Parameter: 
# Return Code....:
 
FUNCTION s_act_desc_file_get_set(lc_show_method)
 
 DEFINE   ps_act          STRING
 DEFINE   lst_act         base.StringTokenizer,
          ls_act          STRING
 DEFINE   li_i            LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 DEFINE   li_array_length LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 DEFINE   ls_return_act   STRING
 DEFINE   lc_show_method  LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
   LET lst_act = base.StringTokenizer.create(mc_default_action CLIPPED, ", ")
  
   # 抓取總數以為回圈搜詢用
   LET li_array_length = ma_act.getLength()
   LET ls_return_act = ""
  
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
   
      # 2004/03/29 : 選擇
      IF lc_show_method="Y" THEN
         FOR li_i = 1 TO li_array_length
            IF ls_act = ma_act[li_i].act_name THEN
               LET ls_return_act = ls_return_act.append(ma_act[li_i].act_desc)
               LET ls_return_act = ls_return_act.append(" \n")
            END IF
         END FOR
      ELSE
         FOR li_i = 1 TO li_array_length
            IF ls_act = ma_act[li_i].act_name THEN
               LET ls_return_act = ls_return_act.append(ma_act[li_i].act_desc)
               LET ls_return_act = ls_return_act.append(", ")
            END IF
         END FOR
      END IF
  
   END WHILE
 
   RETURN ls_return_act
 
END FUNCTION
 
