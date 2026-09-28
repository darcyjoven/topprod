# Prog. Version..: '5.30.10-13.11.15(00000)'     #
#
# Program name...: s_i403_dbload.4gl
# Descriptions...: 資料匯入及將資料匯出Excel範本
# Date & Author..: 2013/08/06 By zhuhao(FUN-D70055)
# Usage..........: CALL i403_dbload() 根據單頭資料匯入單身資料
# Comment........: 需注意4fd的tabIndex順序是否正確,會影響輸出的欄位順序

IMPORT os 
DATABASE ds     
 
GLOBALS "../../config/top.global"

GLOBALS
   DEFINE ms_codeset      STRING
   DEFINE ms_locale       STRING
   DEFINE xls_name        STRING
END GLOBALS
 
DEFINE g_file          STRING                #文件名稱
DEFINE tsconv_cmd      STRING
DEFINE g_n             LIKE type_file.num10,
       g_cnt           LIKE type_file.num10
DEFINE l_win_name      STRING,
       cnt_header      LIKE type_file.num10
DEFINE g_sheet         STRING
DEFINE g_hidden        DYNAMIC ARRAY OF LIKE type_file.chr1,
       g_ifchar        DYNAMIC ARRAY OF LIKE type_file.chr1,
       g_mask          DYNAMIC ARRAY OF LIKE type_file.chr1,
       g_quote         STRING
DEFINE g_sort          RECORD
       column          LIKE type_file.num5,    #sortColumn
       type            STRING                  #sortType:排序方式:asc/desc
                        END RECORD
DEFINE lr_data   DYNAMIC ARRAY OF RECORD
       ccf01      LIKE ccf_file.ccf01,
       ccf02      LIKE ccf_file.ccf02,
       ccf03      LIKE ccf_file.ccf03,
       ccf06      LIKE ccf_file.ccf06,
       ccf07      LIKE ccf_file.ccf07,
       ccf04      LIKE ccf_file.ccf04,
       ccf05      LIKE ccf_file.ccf05,
       ccf11      LIKE ccf_file.ccf11,
       ccf12a     LIKE ccf_file.ccf12a,
       ccf12b     LIKE ccf_file.ccf12b,
       ccf12c     LIKE ccf_file.ccf12c,
       ccf12d     LIKE ccf_file.ccf12d,
       ccf12e     LIKE ccf_file.ccf12e,
       ccf12f     LIKE ccf_file.ccf12f,
       ccf12g     LIKE ccf_file.ccf12g,
       ccf12h     LIKE ccf_file.ccf12g,
       ccf12      LIKE ccf_file.ccf12
       END RECORD
DEFINE  l_channel       base.Channel,
        l_field_name    STRING,
        cnt_table       LIKE type_file.num10
          
#資料匯入:通過excel模板錄入單身資料
FUNCTION i403_dbload()

   OPEN WINDOW i403_o_w WITH FORM "axc/42f/axci403_dbload" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axci403_dbload")

   WHENEVER ERROR CALL cl_err_msg_log
 
   CLEAR FORM
   ERROR ''
   WHILE TRUE
      INPUT g_file
      WITHOUT DEFAULTS FROM FORMONLY.file
      
         ON ACTION locale   
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()          
            EXIT INPUT
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
    
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION controlf
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i403_o_w
         RETURN
      END IF
        
      IF cl_sure(0,0) THEN
         LET g_n = 0    
         LET g_cnt = 0    
         LET g_success='Y'
        #BEGIN WORK        
         CALL i403_load()
         CALL s_showmsg()  
         CALL cl_err_msg("","agl1013",g_n CLIPPED|| "|" || g_cnt CLIPPED,0)
        #IF g_success = 'Y' THEN
        #   COMMIT WORK
        #ELSE
        #   ROLLBACK WORK
        #   CONTINUE WHILE
        #END IF
         EXIT WHILE
      ELSE
         CONTINUE WHILE
      END IF
   END WHILE
   CLOSE WINDOW i403_o_w
END FUNCTION

FUNCTION i403_load()
  DEFINE  m_tempdir   LIKE type_file.chr1000,    
          ss1          LIKE type_file.chr1000,
          m_sf        LIKE type_file.chr1000,
          m_file      LIKE type_file.chr1000,
          l_n         LIKE type_file.num5
  
   CALL s_showmsg_init()
   LET g_success='Y'
   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
   
   
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF
 
   IF m_tempdir IS NULL THEN
      LET m_file=g_file,".xls"
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',g_file,".xls" 
   END IF
 
   LET m_sf = "c:/tiptop/"
   LET m_sf = m_sf CLIPPED,g_file CLIPPED,".xls"
   IF NOT cl_upload_file(m_sf, m_file) THEN
      CALL cl_err(NULL, "lib-212", 1)
      RETURN
   END IF
   LET ss1="test -s ",m_file CLIPPED
   -- l_n=0 if the file is exist;
   -- otherwise there is no such file
   RUN ss1 RETURNING l_n

   IF l_n THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF

      DISPLAY "* NOTICE * No such file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_err(m_file,'aap-186',1)
      RETURN
   END IF

   CALL i403_from_excel(m_sf,g_file)

   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF  
END FUNCTION

#excel格式導入
FUNCTION i403_from_excel(p_path,p_file)
   DEFINE p_path       STRING,
          p_file       STRING
   DEFINE li_result    LIKE type_file.num5,
          li_i         LIKE type_file.num5,
          li_j         LIKE type_file.num5,
          li_cnt       LIKE type_file.num5,
          li_col_idx   LIKE type_file.num5,
          ls_cell      STRING,
          ls_cell2     STRING,
          ls_cell_r    STRING,
          ls_cell_c    STRING,
          ls_cell_r2   STRING,
          ls_value     STRING
   DEFINE l_sql        STRING
   DEFINE l_chr   LIKE type_file.chr1,
          l_bdate  LIKE sma_file.sma53, 
          l_edate  LIKE sma_file.sma53  
   
   LET p_path=cl_replace_str(p_path,"/","\\")
   LET p_file=p_file,".xls"
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
 
   CALL ui.Interface.frontCall("standard","shellexec",[p_path] ,li_result)
   CALL s_i403_checkerror(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",p_file],[li_result])
   CALL s_i403_checkerror(li_result,"Connect File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL s_i403_checkerror(li_result,"Connect Sheet1")
 
   MESSAGE p_file," File Analyze..."
   
   #準備解Excel內的資料
   #第一階段搜尋
   LET li_col_idx = 1
   LET li_i=1
   WHILE TRUE   #1->excel中的栏位数
      #判断第一行第li_i列是否有值,如果有值说明需要抓取改列一下资料,否则列到此结束
      LET ls_cell_c=li_i
      LET ls_cell = "R1C",ls_cell_c.trim()
      CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",p_file,ls_cell],[li_result,ls_value])
      CALL s_i403_checkerror(li_result,"Peek Cells")
      LET ls_value = ls_value.trim()
      IF ls_value.getIndexOf("\"",1) THEN
         LET ls_value = cl_replace_str(ls_value,'"','@#$%')
         LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
      END IF
      IF ls_value.getIndexOf("'",1) THEN
         LET ls_value = cl_replace_str(ls_value,"'","@#$%")
         LET ls_value = cl_replace_str(ls_value,"@#$%","''")
      END IF
      IF cl_null(ls_value) THEN EXIT WHILE END IF
      
      #直接默认取列，直向
      #R2C1  第二行第一列开始
      #將抓到的資料放到lr_data
      LET li_cnt = 1
      LET li_j=2
      WHILE TRUE
          LET ls_value = ""
          LET ls_cell_r = li_j
          LET ls_cell = "R",ls_cell_r.trim(),"C",ls_cell_c.trim()
          CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",p_file,ls_cell],[li_result,ls_value])
          CALL s_i403_checkerror(li_result,"Peek Cells")
          LET ls_value = ls_value.trim()
          IF ls_value.getIndexOf("\"",1) THEN
             LET ls_value = cl_replace_str(ls_value,'"','@#$%')
             LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
          END IF
          IF ls_value.getIndexOf("'",1) THEN
             LET ls_value = cl_replace_str(ls_value,"'","@#$%")
             LET ls_value = cl_replace_str(ls_value,"@#$%","''")
          END IF

          CASE li_col_idx
             WHEN 1
                LET lr_data[li_cnt].ccf01 = ls_value
             WHEN 2
                LET lr_data[li_cnt].ccf02 = ls_value
             WHEN 3
                LET lr_data[li_cnt].ccf03 = ls_value
             WHEN 4
                LET lr_data[li_cnt].ccf06 = ls_value
             WHEN 5
                LET lr_data[li_cnt].ccf07 = ls_value
             WHEN 6
                LET lr_data[li_cnt].ccf04 = ls_value
             WHEN 7
                LET lr_data[li_cnt].ccf05 = ls_value
             WHEN 8
                LET lr_data[li_cnt].ccf11 = ls_value
             WHEN 09
                LET lr_data[li_cnt].ccf12a = ls_value
             WHEN 10
                LET lr_data[li_cnt].ccf12b = ls_value
             WHEN 11
                LET lr_data[li_cnt].ccf12c = ls_value
             WHEN 12
                LET lr_data[li_cnt].ccf12d = ls_value
             WHEN 13
                LET lr_data[li_cnt].ccf12e = ls_value
             WHEN 14
                LET lr_data[li_cnt].ccf12f = ls_value
             WHEN 15
                LET lr_data[li_cnt].ccf12g = ls_value
             WHEN 16
                LET lr_data[li_cnt].ccf12h = ls_value
             WHEN 17
                LET lr_data[li_cnt].ccf12 = ls_value
          END CASE

          IF cl_null(lr_data[li_cnt].ccf01) THEN EXIT WHILE END IF
       #  IF cl_null(lr_data[li_cnt].ccf01) OR cl_null(lr_data[li_cnt].ccf02) OR 
       #     cl_null(lr_data[li_cnt].ccf03) THEN
       #     EXIT WHILE
       #  END IF
       #  IF cl_null(lr_data[li_cnt].ccf04) THEN lET lr_data[li_cnt].ccf04 = ' ' END IF
       #  IF cl_null(lr_data[li_cnt].ccf06) THEN 
       #     IF g_ccz.ccz28 = '6' THEN
       #        CALL cl_err('','axc-026',1)
       #        EXIT WHILE
       #     ELSE
       #        LET lr_data[li_cnt].ccf06 = g_ccz.ccz28
       #     END IF
       #  END IF
       #  IF cl_null(lr_data[li_cnt].ccf07) THEN LET lr_data[li_cnt].ccf07 = ' ' END IF
       #  IF cl_null(lr_data[li_cnt].ccf05) THEN LET lr_data[li_cnt].ccf05 = ' ' END IF
       #  IF cl_null(lr_data[li_cnt].ccf11) THEN LET lr_data[li_cnt].ccf11 = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12) THEN LET lr_data[li_cnt].ccf12 = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12a) THEN LET lr_data[li_cnt].ccf12a = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12b) THEN LET lr_data[li_cnt].ccf12b = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12c) THEN LET lr_data[li_cnt].ccf12c = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12d) THEN LET lr_data[li_cnt].ccf12d = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12e) THEN LET lr_data[li_cnt].ccf12e = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12f) THEN LET lr_data[li_cnt].ccf12f = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12g) THEN LET lr_data[li_cnt].ccf12g = 0 END IF
       #  IF cl_null(lr_data[li_cnt].ccf12h) THEN LET lr_data[li_cnt].ccf12h = 0 END IF
          LET li_j=li_j+1 
          LET li_cnt = li_cnt + 1
      END WHILE
      LET li_col_idx = li_col_idx + 1
      LET li_i=li_i+1
   END WHILE
   CALL lr_data.deleteElement(li_cnt)
   
   FOR li_i = 1 TO lr_data.getLength()
       IF cl_null(lr_data[li_i].ccf07) THEN LET lr_data[li_i].ccf07 = ' ' END IF
       IF NOT cl_null(lr_data[li_i].ccf02) AND NOT cl_null(lr_data[li_i].ccf03) THEN
          CALL s_azm(lr_data[li_i].ccf02,lr_data[li_i].ccf03) RETURNING l_chr,l_bdate,l_edate
          IF l_edate <= g_sma.sma53 THEN
             LET g_showmsg=lr_data[li_i].ccf01,'/',lr_data[li_i].ccf02,'/',lr_data[li_i].ccf03,
                           '/',lr_data[li_i].ccf04,'/',lr_data[li_i].ccf06,'/',lr_data[li_i].ccf07
             CALL s_errmsg('ccf01,ccf02,ccf03,ccf04,ccf06,ccf07',g_showmsg,'','alm1561',1)
             LET g_cnt=g_cnt+1
             CONTINUE FOR
          END IF
       END IF
       INSERT INTO ccf_file(ccf00,ccf01,ccf02,ccf03,ccf04,ccf05,ccf06,ccf07,ccf11,
                            ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h,ccf12,
                            ccfacti,ccfuser,ccfgrup,ccfmodu,ccfdate,ccflegal,ccforiu,ccforig)
            VALUES('1',lr_data[li_i].ccf01,lr_data[li_i].ccf02,lr_data[li_i].ccf03,lr_data[li_i].ccf04,
                   lr_data[li_i].ccf05,lr_data[li_i].ccf06,lr_data[li_i].ccf07,lr_data[li_i].ccf11,
                   lr_data[li_i].ccf12a,lr_data[li_i].ccf12b,lr_data[li_i].ccf12c,lr_data[li_i].ccf12d,
                   lr_data[li_i].ccf12e,lr_data[li_i].ccf12f,lr_data[li_i].ccf12g,lr_data[li_i].ccf12h,
                   lr_data[li_i].ccf12,'Y',g_user,g_grup,'',g_today,g_legal,g_user,g_grup)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
          LET g_success='N'
          LET g_showmsg=lr_data[li_i].ccf01,'/',lr_data[li_i].ccf02,'/',lr_data[li_i].ccf03,
                        '/',lr_data[li_i].ccf04,'/',lr_data[li_i].ccf06,'/',lr_data[li_i].ccf07
          CALL s_errmsg('ccf01,ccf02,ccf03,ccf04,ccf06,ccf07',g_showmsg,'',SQLCA.sqlcode,1)
          LET g_cnt=g_cnt+1
       ELSE
          LET g_n=g_n+1
       END IF
   END FOR
   #關閉Excel寫入
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])
   CALL s_i403_checkError(li_result,"Finish")
END FUNCTION

FUNCTION s_i403_checkerror(res,p_msg)
   DEFINE res  LIKE type_file.num10    
   DEFINE mess STRING
   DEFINE p_msg      STRING
   
   IF res THEN RETURN END IF
   DISPLAY p_msg," DDE Error:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[mess]);
   DISPLAY mess
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll", [], [res] );
   DISPLAY "Exit with DDE Error."
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   EXIT PROGRAM (-1)
END FUNCTION

FUNCTION i403_excelexample(n,t,p_show_hidden)
 DEFINE  t,t1,t2,n1_text,n3_text         om.DomNode,
         n,n2,n_child                    om.DomNode,
         p_show_hidden                   LIKE type_file.chr1,    #隱藏欄位是否顯示
         n1,n_table,n3                   om.NodeList,
         i,res,p,q,k                     LIKE type_file.num10,
         h                               LIKE type_file.num10,
         cnt_combo_data,cnt_combo_tot    LIKE type_file.num10,
         cells,values,j,l,sheet,cc       STRING,
         table_name,l_length             STRING,
         l_table_name                    LIKE gac_file.gac05,
         l_datatype                      LIKE type_file.chr20,
         l_bufstr                        base.StringBuffer,
         lwin_curr                       ui.Window,
         l_show                          LIKE type_file.chr1,
         l_time                          LIKE type_file.chr8

 DEFINE  combo_arr        DYNAMIC ARRAY OF RECORD
           sheet          LIKE type_file.num10,
           seq            LIKE type_file.num10,
           name           LIKE type_file.chr2,
           text           LIKE type_file.chr50
                          END RECORD
 DEFINE  customize_table  LIKE type_file.chr1
 DEFINE  l_str            STRING
 DEFINE  l_i              LIKE type_file.num5
 DEFINE  buf              base.StringBuffer
 DEFINE  l_dec_point      STRING,
         l_qry_name       LIKE gab_file.gab01,
         l_cust           LIKE gab_file.gab11
 DEFINE  l_tabIndex       LIKE type_file.num10
 DEFINE  l_seq            DYNAMIC ARRAY OF LIKE type_file.num10
 DEFINE  l_seq2           DYNAMIC ARRAY OF LIKE type_file.num10
 DEFINE  l_j              LIKE type_file.num5
 DEFINE  bFound           LIKE type_file.num5
 DEFINE  l_dbname         STRING
 DEFINE  l_zal09          LIKE zal_file.zal09
 DEFINE  l_desc           STRING

   WHENEVER ERROR CALL cl_err_msg_log

   LET cnt_table = 1

   LET l_bufstr = base.StringBuffer.create()
   WHENEVER ERROR CALL cl_err_msg_log
   LET lwin_curr = ui.window.getCurrent()

   LET l_channel = base.Channel.create()
   LET l_time = TIME(CURRENT)
   LET xls_name = g_prog CLIPPED,l_time CLIPPED,".xls"

   LET buf = base.StringBuffer.create()
   CALL buf.append(xls_name)
   CALL buf.replace( ":","-", 0)
   LET xls_name = buf.toString()

   # 個資會記錄使用者的行為模式，在此說明excel的檔名及匯出excel的方式
   LET l_desc = xls_name CLIPPED," Using HTML to export the Table to excel."

   IF os.Path.delete(xls_name CLIPPED) THEN END IF
   CALL l_channel.openFile( xls_name CLIPPED, "a" )
   CALL l_channel.setDelimiter("")

   IF ms_codeset.getIndexOf("BIG5", 1) OR
      ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET tsconv_cmd = "big5_to_gb2312"
         LET ms_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET tsconv_cmd = "gb2312_to_big5"
         LET ms_codeset = "BIG5"
      END IF
   END IF

   LET l_str = "<html xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("<head><style><!--")

   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN
      IF g_lang = "0" THEN  #繁體中文
         CALL l_channel.write("td  {font-family:細明體, serif;}")
      ELSE
         IF g_lang = "2" THEN  #簡體中文
            CALL l_channel.write("td  {font-family:新宋体, serif;}")
         ELSE
            CALL l_channel.write("td  {font-family:細明體, serif;}")
         END IF
      END IF
   ELSE
      CALL l_channel.write("td  {font-family:Courier New, serif;}")
   END IF

   LET l_str = ".xl24  {mso-number-format:",g_quote,"\@",g_quote,";}",
               ".xl30 {mso-style-parent:style0; mso-number-format:\"0_ \";} ",
               ".xl31 {mso-style-parent:style0; mso-number-format:\"0\.0_ \";} ",
               ".xl32 {mso-style-parent:style0; mso-number-format:\"0\.00_ \";} ",
               ".xl33 {mso-style-parent:style0; mso-number-format:\"0\.000_ \";} ",
               ".xl34 {mso-style-parent:style0; mso-number-format:\"0\.0000_ \";} ",
               ".xl35 {mso-style-parent:style0; mso-number-format:\"0\.00000_ \";} ",
               ".xl36 {mso-style-parent:style0; mso-number-format:\"0\.000000_ \";} ",
               ".xl37 {mso-style-parent:style0; mso-number-format:\"0\.0000000_ \";} ",
               ".xl38 {mso-style-parent:style0; mso-number-format:\"0\.00000000_ \";} ",
               ".xl39 {mso-style-parent:style0; mso-number-format:\"0\.000000000_ \";} ",
               ".xl40 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} "
   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("--></style>")
   CALL l_channel.write("<!--[if gte mso 9]><xml>")
   CALL l_channel.write("<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>")
   CALL l_channel.write("<x:DefaultRowHeight>330</x:DefaultRowHeight>")
   CALL l_channel.write("</xml><![endif]--></head>")
   CALL l_channel.write("<body><table border=1 cellpadding=0 cellspacing=0 width=432 style='border-collapse: collapse;table-layout:fixed;width:324pt'>")

   CALL l_channel.write("<tr height=22>")

   LET l_win_name = NULL
   LET l_win_name = n.getAttribute("name")

   LET n_table = n.selectByTagName("Table")
   CALL combo_arr.clear()
   FOR h=1 to cnt_table
      CALL g_hidden.clear()
      CALL g_ifchar.clear()
      CALL g_mask.clear()
      LET n2 = n_table.item(h)

      IF l_win_name = "p_dbqry_table" THEN
         LET n1 = n2.selectByPath("//TableColumn[@hidden=\"0\"]")
      ELSE
         LET n1 = n2.selectByTagName("TableColumn")
      END IF

      #抓取 table 是否有進行欄位排序
      INITIALIZE g_sort.* TO NULL
      LET g_sort.column = n2.getAttribute("sortColumn")
      IF g_sort.column >=0 AND g_sort.column IS NOT NULL  THEN
         LET g_sort.column = g_sort.column + 1    #屬性 sortColumn 為 0 開始
         LET g_sort.type = n2.getAttribute("sortType")
      END IF

      LET cnt_header = n1.getLength()
      LET l = h
      LET sheet=g_sheet  CLIPPED,l
      LET k = 0

      CALL l_seq.clear()
      CALL l_seq2.clear()

     #循環Table中的每一個列
     FOR i=1 TO cnt_header
       #得到對應的DomNode節點
       LET n1_text = n1.item(i)
       #得到該列的TabIndex屬性
       LET l_tabIndex = n1_text.getAttribute("tabIndex")

       #如果TabIndex屬性不為空
       IF NOT cl_null(l_tabIndex) THEN
          #初始化一個標志變量（表明是否在數組中找到比當前TabIndex更大的節點）
          LET bFound = FALSE
          #開始在已有的數組中定位比當前tabIndex大的成員
          FOR l_j=1 TO l_seq2.getLength()
              #如果有找到
              IF l_seq2[l_j] > l_tabIndex THEN
                 #設置標志變量
                 LET bFound = TRUE
                 #退出搜尋過程（此時下標j保存的該成員變量的位置）
                 EXIT FOR
              END IF
          END FOR
          #如果始終沒有找到（比如數組根本就是空的）那麼j里面保存的就是當前數組最大下標+1
          #判斷有沒有找到
          IF bFound THEN
             #如果找到則向該數組中插入一個元素（在這個tabIndex比它大的元素前面插入)
             CALL l_seq2.InsertElement(l_j)
             CALL l_seq.InsertElement(l_j)
          END IF
          #把當前的下標（列的位置）和tabIndex填充到這個位置上
          #如果沒有找到，則填充的位置會是整個數組的末尾
          LET l_seq[l_j] = i
          LET l_seq2[l_j] = l_tabIndex
       END IF
     END FOR

     FOR i=1 to cnt_header
        LET n1_text = n1.item(l_seq[i])
        LET k = k + 1
        LET j = k
        LET cells = "R1C" CLIPPED,j
        LET l_field_name = NULL
        LET l_show = n1_text.getAttribute("hidden")
        IF ((p_show_hidden = 'N' OR p_show_hidden IS NULL) AND (l_show = "0" OR l_show IS NULL)) OR p_show_hidden = 'Y' THEN
           LET l_field_name = n1_text.getAttribute("name")
           IF l_field_name = 'formonly.ccf01' OR l_field_name = 'formonly.ccf02' OR
              l_field_name = 'formonly.ccf03' OR l_field_name = 'formonly.ccf04' OR
              l_field_name = 'formonly.ccf05' OR l_field_name = 'formonly.ccf06' OR
              l_field_name = 'formonly.ccf07' OR l_field_name = 'formonly.ccf11' OR
              l_field_name = 'formonly.ccf12a' OR l_field_name = 'formonly.ccf12b' OR
              l_field_name = 'formonly.ccf12c' OR l_field_name = 'formonly.ccf12d' OR
              l_field_name = 'formonly.ccf12e' OR l_field_name = 'formonly.ccf12f' OR
              l_field_name = 'formonly.ccf12g' OR l_field_name = 'formonly.ccf12h' OR
              l_field_name = 'formonly.ccf12'  THEN
              LET values = n1_text.getAttribute("text")
              LET l_str = "<td>",cl_add_span(values),"</td>"
              CALL l_channel.write(l_str CLIPPED)
           END IF
        ELSE
           LET g_hidden[i] = "1"
           LET k = k -1
        END IF
     END FOR
     IF h=1 THEN CALL i403_get_body(h,cnt_header,t,combo_arr,l_seq) END IF

   END FOR

   # 使用者的行為模式改到前面判斷，在此僅將前面判斷的結果說明傳至syslog中做紀錄
   IF cl_syslog("A","G",l_desc) THEN
   END IF

END FUNCTION

FUNCTION i403_get_body(p_h,p_cnt_header,s,s_combo_arr,p_seq)
 DEFINE  s,n1_text                          om.DomNode,
         n1                                 om.NodeList,
         i,m,k,cnt_body,res,p               LIKE type_file.num10,
         l_hidden_cnt,n,l_last_hidden       LIKE type_file.num10,
         p_h,p_cnt_header,arr_len           LIKE type_file.num10,
         p_null                             LIKE type_file.num10,
         cells,values,j,l,sheet             STRING,
         l_bufstr                           base.StringBuffer

 DEFINE  s_combo_arr    DYNAMIC ARRAY OF RECORD
          sheet         LIKE type_file.num10,       #sheet
          seq           LIKE type_file.num10,       #項次
          name          LIKE type_file.chr2,        #代號
          text          LIKE type_file.chr50        #說明
                        END RECORD
 DEFINE  p_seq          DYNAMIC ARRAY OF LIKE type_file.num10
 DEFINE  l_item         LIKE type_file.num10

 DEFINE  unix_path      STRING,
         window_path    STRING
 DEFINE  l_dom_doc      om.DomDocument,
         r,n_node       om.DomNode
 DEFINE  l_status       LIKE type_file.num5
 DEFINE  l_str          STRING

   LET l_hidden_cnt = 0
   LET l = p_h
   LET sheet=g_sheet CLIPPED,l
   LET l_bufstr = base.StringBuffer.create()
   LET l = 0
   LET i = 0
   LET m = 0

   CALL l_channel.write("</tr></table></body></html>")
   CALL l_channel.close()
   CALL cl_prt_convert(xls_name)

   #此處為組出 URL Address,不需代換
   LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
   IF g_prog!="p_thousand" THEN
      CALL ui.Interface.frontCall("standard",
                               "shellexec",
                               ["EXPLORER \"" || l_str || "\""],
                               [res])
   END IF
   IF STATUS THEN
      CALL cl_err("Front End Call failed.", STATUS, 1)
      RETURN
   END IF
END FUNCTION

#FUN-D70055 add
