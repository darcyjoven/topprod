# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_thousand.4gl 
# Descriptions...: 批次將數量/金額欄位做三位一撇的功能
# Date & Author..: 2011/12/20 by henry
# Modify.........: No:FUN-B40009 2011/12/20 By henry
# Modify.........: No:MOD-D10158 2013/01/18 By henry 只能輸入資料型態為number的欄位屬性

IMPORT os

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS
   DEFINE xls_name STRING #抓取cl_export_to_excel的儲存檔名 #FUN-B40009
END GLOBALS
 
DEFINE
   g_attr_tb     DYNAMIC ARRAY OF RECORD   #存放要選取的屬性資料
      gck01         LIKE gck_file.gck01,   #欄位屬性代碼
      gck02         LIKE gck_file.gck02    #屬性簡稱
                 END RECORD,

   g_mod_tb      DYNAMIC ARRAY OF RECORD   #存放要選取的模組資料
      choose        LIKE type_file.chr1,
      gao01         LIKE gao_file.gao01,   #模組代號
      gaz03         LIKE gaz_file.gaz03    #模組名稱
                 END RECORD,

   g_prog_tb     DYNAMIC ARRAY OF RECORD   #存放要選取的程式資料
      choose        LIKE type_file.chr1,  
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03    #程式名稱
                 END RECORD,

   g_prog_nu     DYNAMIC ARRAY OF RECORD   #存放未更新程式資料
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03    #程式名稱
                 END RECORD,

   g_prog_ud     DYNAMIC ARRAY OF RECORD   #存放已更新的欄位和程式的資料
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03,   #程式名稱
      gaq01         LIKE gaq_file.gaq01,   #欄位代號
      gaq03         LIKE gaq_file.gaq03,   #欄位名稱
      gck02         LIKE gck_file.gck02,   #屬性簡稱
      ac            STRING,                #執行動作
      result        LIKE gav_file.gav06    #l執行結果
                 END RECORD,

   g_prog_err    DYNAMIC ARRAY OF RECORD   #存放該做未做程式資料
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03,   #程式名稱
      gck02         LIKE gck_file.gck02,   #屬性簡稱
      err           STRING,                #未處理原因
      result        LIKE gav_file.gav06    #執行結果
                 END RECORD,

   g_prog_list   DYNAMIC ARRAY OF RECORD   #存放處理程式清單
      gao01         LIKE gao_file.gao01,   #模組別
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03    #程式名稱
                 END RECORD,
 
   g_prog_id     DYNAMIC ARRAY OF RECORD   #存放要處理的程式資料
      gaz01         LIKE gaz_file.gaz01,   #程式代號
      gaz03         LIKE gaz_file.gaz03    #程式名稱
                 END RECORD
                      
DEFINE   g_wc2   STRING                    #挑選屬性的where條件
DEFINE   g_sql   STRING                    #存放抓取資料的SQL指令
DEFINE   g_cnt   LIKE type_file.num10      #紀錄陣列的資料筆數
DEFINE   g_rec_b   LIKE type_file.num5      #目前單身總筆數
DEFINE p_thousand_w1 ui.Window
DEFINE tb5_node  om.DomNode
DEFINE tb6_node  om.DomNode

#主要的程式
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT   

   IF (NOT cl_user()) THEN              #設定關於使用者與系統公用變數的設定
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log   #紀錄錯誤訊息
 
   IF (NOT cl_setup("AZZ")) THEN        #程式執行的基本設定,傳入模組代號
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time            #計錄程式被執行的開始時間
   OPEN WINDOW p_thousand_w WITH FORM "azz/42f/p_thousand"   #載入畫面檔
      ATTRIBUTE(STYLE=g_win_style)

   CALL cl_ui_init()                                         #程式設定初始化
   CALL p_thousand_set_combo_industry("gav11") #設定行業別
   LET g_wc2="gck01='019' OR gck01='020'",                  #預設屬性項目
       " OR gck01='021' OR gck01='022'"     
   #LET g_wc2="gck01='004' OR gck01='005'",                  #預設屬性項目
       #" OR gck01='022' OR gck01='023'"
   #LET g_wc2="gck01='022'"                                   #預設屬性項目
       
   CALL p_thousand_attr_fill(g_wc2)                          #預先載入資料庫的屬性資料
   CALL p_thousand_mod_fill()                                #預先載入資料庫的模組資料
   CALL p_thousand_menu()                                    #產生畫面
   CLOSE WINDOW p_thousand_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #計錄程式被執行的結束時間
END MAIN

#顯示畫面,主要用Multiple Dialog來控制所有的Dialog
FUNCTION p_thousand_menu()   

   DEFINE   l_ucd          LIKE type_file.chr1     #存放設否更新客製資料的值
   DEFINE   l_ads          LIKE type_file.chr2     #存放新增屬性設定或移除屬性設定的值
   DEFINE   l_atmp         LIKE type_file.chr3     #存放根據模組或根據程式的值
   DEFINE   l_pcm          LIKE type_file.chr10    #存放模組代號
   DEFINE   l_pcm_tmp      STRING                  #暫存模組代號
   DEFINE   l_mn           LIKE type_file.chr100   #存放模組說明
   DEFINE   l_gav11        LIKE type_file.chr10    #行業別
   
   DEFINE   l_gck01_add    base.StringTokenizer    #存放加入的屬性字串作token
   DEFINE   l_gck01_del    base.StringTokenizer    #存放刪除的屬性字串作token
   DEFINE   l_wc2_buffer   base.StringBuffer       #存放字串進行取代功能用
   DEFINE   l_gck01          STRING                #暫存開窗後的回傳的欄位屬性代碼
   DEFINE   l_gck01_tmp          STRING
   DEFINE   l_row_count    LIKE type_file.num5
   DEFINE   l_gck02          STRING                #暫存開窗後的回傳的屬性簡稱
   DEFINE   l_ac             LIKE type_file.num5   #目前處理的單身筆數
   DEFINE   l_nox            LIKE type_file.num5
   DEFINE   l_frag           LIKE type_file.chr1
   DEFINE   l_server_path STRING
   DEFINE   l_client_path STRING

   CALL cl_set_act_visible("accept,cancel,Insert,Delete", FALSE)
   CALL cl_set_act_visible("execution_action", FALSE)
   CALL cl_set_act_visible("check_detail", FALSE)

   
   CALL ui.Dialog.setDefaultUnbuffered(TRUE)       #設定DIALOG全程都是UNBUFFERED,即時顯示陣列內的資料

   DIALOG #ATTRIBUTE(UNBUFFERED=TRUE) #UNBUFFERED=TRUE設定DIALOG全程都是UNBUFFERED,即時顯示陣列內的資料
      
      #########是否更新客製資料#########
      INPUT l_ucd FROM s_ucd   
         BEFORE INPUT
            CALL cl_set_act_visible("execution_action,ac,nc", FALSE)
         ON CHANGE s_ucd
      END INPUT

      #########增加屬性設定或刪除屬性設定#########
      INPUT l_ads FROM s_ads   
         ON CHANGE s_ads
            NEXT FIELD gck01
      END INPUT

      #########設定行業別#########
      INPUT l_gav11 FROM gav11
         
         ON CHANGE gav11
            #DISPLAY "HENRY:l_gav11=",l_gav11
      END INPUT
  
      #########屬性欄位#########
      INPUT ARRAY g_attr_tb FROM s_tb1.*  ATTRIBUTE (WITHOUT DEFAULTS=TRUE,
         APPEND ROW=TRUE,AUTO APPEND=TRUE,DELETE ROW=TRUE,
         INSERT ROW=TRUE)#(COUNT=g_rec_b,MAXCOUNT=g_max_rec)
         
         BEFORE ROW
            LET l_ac = ARR_CURR()
            #DISPLAY "###################################"
            FOR l_nox=1 TO g_attr_tb.getlength()
               #DISPLAY "HENRY:",g_attr_tb[l_nox].gck01
            END FOR

         BEFORE DELETE
            IF NOT (cl_delete()) THEN         #詢問〝是否刪除此筆資料？〞
               CANCEL DELETE
            END IF

         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_gck01_tmp = g_attr_tb[l_ac].gck01
            #DISPLAY "",l_gck01_tmp.getLength()
            
            IF l_gck01_tmp.getLength()=0 THEN
               CALL g_attr_tb.deleteElement(l_ac)
            END IF


            SELECT COUNT(*) INTO l_row_count FROM gck_file 
               WHERE gck01 = g_attr_tb[l_ac].gck01 AND gck03 LIKE 'number%'#MOD-D10158

            IF l_row_count=0 AND l_gck01_tmp.getLength()>0 THEN #檢查存在
               CALL cl_err('',"azz1302",1)
               NEXT FIELD gck01
            ELSE
               SELECT gck02 INTO g_attr_tb[l_ac].gck02 FROM gck_file 
                  WHERE gck01 = g_attr_tb[l_ac].gck01

               FOR l_nox=1 TO g_attr_tb.getlength()
               IF l_gck01_tmp = g_attr_tb[l_nox].gck01 AND l_nox != l_ac THEN #檢查重複
                  CALL cl_err('',-239,1)
                  NEXT FIELD gck01
               END IF
               END FOR
               
            END IF

         #AFTER INPUT
            #LET l_ac = ARR_CURR()
            #LET l_gck01_tmp = g_attr_tb[l_ac].gck01
            #DISPLAY "",l_gck01_tmp.getLength()
            #
            #IF l_gck01_tmp.getLength()=0 THEN
               #CALL g_attr_tb.deleteElement(l_ac)
            #END IF
#
#
            #SELECT COUNT(*) INTO l_row_count FROM gck_file 
               #WHERE gck01 = g_attr_tb[l_ac].gck01
#
            #IF l_row_count=0 AND l_gck01_tmp.getLength()>0 THEN #檢查存在
               #CALL cl_err('',"aic-004",1)
               #CALL g_attr_tb.deleteElement(l_ac)
               #CALL FGL_DIALOG_SETCURRLINE( l_ac, l_ac)
            #ELSE
               #SELECT gck02 INTO g_attr_tb[l_ac].gck02 FROM gck_file 
                  #WHERE gck01 = g_attr_tb[l_ac].gck01
#
               #FOR l_nox=1 TO g_attr_tb.getlength()
               #IF l_gck01_tmp = g_attr_tb[l_nox].gck01 AND l_nox != l_ac THEN #檢查重複
                  #CALL cl_err('',-239,1)
                  #CALL g_attr_tb.deleteElement(l_ac)
                  #LET g_attr_tb[l_ac].gck01 = ""
                  #LET g_attr_tb[l_ac].gck02 = ""
                  #CALL FGL_DIALOG_SETCURRLINE( l_ac, l_ac)
               #END IF
               #END FOR
               #
            #END IF
            
         
         ON ACTION controlc                              #加入要設定的屬性
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CALL cl_init_qry_var()
            LET g_qryparam.default1 = g_attr_tb[l_ac].gck01
            LET g_qryparam.default2 = g_attr_tb[l_ac].gck02
            LET g_qryparam.form = "q_gck2"             #進行開窗
            LET g_qryparam.state = "i"                #開窗單選模式
            #LET g_qryparam.where = "NOT(",g_wc2,")"   #開窗where條件
            CALL cl_create_qry() RETURNING l_gck01,l_gck02      #開窗的回傳到l_tmp
            #DISPLAY "HENRY:",l_gck01,"=",l_gck02

            LET g_attr_tb[l_ac].gck01 = l_gck01   #資料顯示在欄位屬性代碼
            LET g_attr_tb[l_ac].gck02 = l_gck02   #資料顯示在屬性簡稱欄位
            CALL DIALOG.setFieldTouched("s_tb1.gck01",TRUE)

      END INPUT

      #########根據模組或根據程式#########
      INPUT l_atmp FROM s_atmp

         ON CHANGE s_atmp
            IF l_atmp = "1" THEN   #若點選 根據模組 則切換到 模組表格的choose欄位
               NEXT FIELD choose
            END IF

            IF l_atmp = "2" THEN   #若點選 根據模組 則切換到 選擇模組欄位
               NEXT FIELD s_pcm
            END IF

      END INPUT

      #########模組欄位輸入#########
      INPUT ARRAY g_mod_tb FROM s_tb2.*  ATTRIBUTE(WITHOUT DEFAULTS=TRUE,
         APPEND ROW=FALSE,AUTO APPEND=FALSE,DELETE ROW=FALSE,
         INSERT ROW=FALSE)

      END INPUT

      #########選擇模組#########
      INPUT l_pcm FROM s_pcm
         BEFORE INPUT
            LET l_pcm_tmp = l_pcm
            CALL cl_set_act_visible("execution_action,ac,nc", FALSE)
         AFTER INPUT
            SELECT COUNT(*) INTO l_row_count FROM gao_file WHERE gao01=UPPER(l_pcm) 
            
            IF l_row_count=0 AND l_pcm IS NOT NULL THEN
            
               CALL cl_err('',"aic-004",1) #檢查存在ˋ
               
               LET l_pcm= l_pcm_tmp
               DISPLAY l_mn TO s_mn
               #CALL cl_set_act_visible("execution_action,ac,nc", FALSE)
               NEXT FIELD s_pcm

            ELSE
            
               SELECT gaz03 INTO l_mn FROM gao_file 
                  LEFT JOIN gaz_file ON gaz01=LOWER(gao01) AND gaz02=g_lang
                  WHERE gao01 = UPPER(l_pcm)

               DISPLAY l_mn TO s_mn                        #顯示模組說明
               CALL p_thousand_prog_fill(l_pcm)            #載入資料庫的程式資料
               CALL cl_set_act_visible("execution_action,ac,nc", TRUE)
               
            END IF

         ON ACTION open_ui_list
            CALL cl_set_act_visible("execution_action,ac,nc", TRUE)
            NEXT FIELD choose2

            
      END INPUT

      #########程式欄位輸入#########
      INPUT ARRAY g_prog_tb FROM s_tb3.*   ATTRIBUTE(WITHOUT DEFAULTS=TRUE,
         APPEND ROW=FALSE,AUTO APPEND=FALSE,DELETE ROW=FALSE,
         INSERT ROW=FALSE)
                  
      END INPUT
      
      #########顯示該做未做程式清單
      DISPLAY ARRAY g_prog_list TO s_tb7.*
      
      END DISPLAY


      #########顯示未變更的程式清單
      DISPLAY ARRAY g_prog_nu TO s_tb4.*
      
      END DISPLAY

      #########顯示已更新程式清單
      DISPLAY ARRAY g_prog_ud TO s_tb5.*
      
      END DISPLAY

      #########顯示該做未做程式清單
      DISPLAY ARRAY g_prog_err TO s_tb6.*
      
      END DISPLAY


      ######### 各DIALOG共用的ON ACTION #########
     # ON ACTION exporttoexcel

        # IF g_prog_list.getLength() >0 THEN 
           # LET p_thousand_w1 = ui.Window.forName("p_thousand_w")
           # LET tb5_node = p_thousand_w1.findNode("Table","tb5")
           # CALL cl_export_to_excel(tb5_node,base.TypeInfo.create(g_prog_ud),'','')
        # END IF


      ON ACTION locale  #多語系
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p_thousand_set_combo_industry("gav11") 
      
      ON ACTION EXIT                #控制TOP MENU的離開
         #DISPLAY "EXIT"
         EXIT DIALOG

      ON ACTION CLOSE               #控制X的按鈕
         LET INT_FLAG=FALSE
         #DISPLAY "CLOSE"
         EXIT DIALOG

      ON ACTION execution_action    #控制右側的執行按鈕

         #傳入客製資料、增刪屬性設定和根據模組程式的參數
         #IF cl_chk_act_auth() THEN
         IF (cl_confirm("azz1203")) THEN
            CALL g_prog_list.clear() #執行前清除存放處理程式清單
            CALL cl_set_action_active("execution_action", FALSE)
            CALL p_thousand_execution(l_ucd,l_ads,l_atmp,l_gav11)

            IF g_prog_ud.getLength()>0 THEN
               CALL p_thousand_updatedList()
            END IF

            #IF g_prog_ud.getLength()!=0 THEN
            IF g_prog_list.getLength() >0 THEN
               LET p_thousand_w1 = ui.Window.forName("p_thousand_w")
               LET tb5_node = p_thousand_w1.findNode("Table","tb5")
               CALL cl_export_to_excel(tb5_node,base.TypeInfo.create(g_prog_ud),'','')
               CALL cl_msgany(0,0,'Detail file server path : '||'$TEMPDIR/'||xls_name)
            END IF
            
            CALL cl_set_act_visible("check_detail", TRUE)
            CALL cl_set_action_active("execution_action", TRUE)
            NEXT FIELD mi
         END IF
         #END IF
      ON ACTION ac
         CALL p_thousand_selectAll(l_atmp)   #全部勾選
   
      ON ACTION nc
         CALL p_thousand_cancelAll(l_atmp)   #全部不勾選
         
      ON ACTION exit_action         #控制右側的離開按鈕
         EXIT DIALOG

     # ON ACTION check_detail         #控制右側的離開按鈕
        # IF (cl_confirm("azz1203")) AND g_prog_list.getLength() >0 THEN
            #DISPLAY "xls_name = ",xls_name
           # LET l_server_path = "$TEMPDIR/",xls_name
           # LET l_client_path = "C:/",xls_name
           # IF NOT cl_download_file(l_server_path,l_client_path) THEN
               #DISPLAY 'Error in downloading d.txt !'
              # CALL cl_msgany(0,0,'Downloading error')
              # RETURN FALSE
           # ELSE
              # CALL cl_msgany(0,0,'File downloaded path : '||l_client_path)
           # END IF
        # END IF 

      ON ACTION atm
         LET l_atmp = "1"   #"1"表示根據模組
         DISPLAY l_atmp TO s_atmp   #利用Page的action屬性控制RadioGroup
         NEXT FIELD choose

      ON ACTION atp
         CALL cl_set_act_visible("execution_action,ac,nc", FALSE)
         LET l_atmp = "2"   #"2"表示根據程式
         DISPLAY l_atmp TO s_atmp   #利用Page的action屬性控制RadioGroup
         NEXT FIELD s_pcm

      ON ACTION visible_exit
         CALL cl_set_act_visible("exit_action", TRUE)
         CALL cl_set_act_visible("execution_action,ac,nc", FALSE)


      ON ACTION visible_all
         CALL cl_set_act_visible("execution_action,ac,nc,exit_action,exit_action", TRUE)

      ON ACTION controlp
         IF INFIELD(s_pcm) THEN
            CALL cl_set_act_visible("accept,cancel", TRUE)
            CALL cl_init_qry_var()
            LET g_qryparam.default1 = l_pcm
            LET g_qryparam.form ="q_gaz3"               #進行開窗 
            LET g_qryparam.state = "i"                  #開窗單選模式
            LET g_qryparam.where = "gaz01=LOWER(gao01) AND gaz02='",g_lang,"'"
            CALL cl_create_qry() RETURNING l_pcm,l_mn   #回傳模組代號和模組說明


            LET l_pcm_tmp = g_qryparam.default1
            IF l_pcm != l_pcm_tmp OR g_qryparam.default1 IS NULL THEN
               DISPLAY l_pcm TO s_pcm                      #顯示模組代號
               LET l_mn = ""
               DISPLAY l_mn TO s_mn                        #顯示模組說明
               CALL p_thousand_prog_fill("")            #載入資料庫的程式資料
            END IF
            NEXT FIELD s_pcm
         END IF
   END DIALOG
END FUNCTION

#載入資料庫的屬性資料
FUNCTION p_thousand_attr_fill(p_wc2)   

   DEFINE p_wc2   STRING

   #從 欄位屬性定義檔(gck_file) 載入 欄位屬性代碼(gck01) 和 屬性簡稱(gck02)
   LET g_sql = "SELECT gck01,gck02 FROM gck_file",
               " WHERE ", p_wc2 CLIPPED

               PREPARE p_thousand_attr FROM g_sql   #組合SQL條件

   DECLARE gck_curs CURSOR FOR p_thousand_attr   #指標指向PREPARE
   CALL g_attr_tb.clear()
   LET g_cnt = 1
   
   FOREACH gck_curs INTO g_attr_tb[g_cnt].*    #指標依序抓取資料到陣列
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH

   CALL g_attr_tb.deleteElement(g_cnt)   #刪除內容為空的元素
   LET g_cnt =g_cnt-1
   #DISPLAY "HENRY:屬性共有",g_cnt,"筆資料"
   
END FUNCTION

#載入資料庫的模組資料
FUNCTION p_thousand_mod_fill()   

   #從 程式名稱多語言記錄檔(gaz_file) 和 模組維護作業檔(gao_file) 
   #載入 模組代號(gao01) ,程式名稱(gaz03)
   LET g_sql = "SELECT '',gao01,gaz03 FROM gao_file LEFT JOIN gaz_file",
               " ON gaz01=LOWER(gao01) AND gaz02='",g_lang,"'",
               " WHERE ", '1=1' CLIPPED,
               " ORDER BY gao01"
   PREPARE p_thousand_mod FROM g_sql
   DECLARE gao_curs CURSOR FOR p_thousand_mod
   CALL g_mod_tb.clear()
   LET g_cnt = 1
 
   FOREACH gao_curs INTO g_mod_tb[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      ELSE
         LET g_mod_tb[g_cnt].choose = "N"
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_mod_tb.deleteElement(g_cnt)
   LET g_cnt =g_cnt-1
   #DISPLAY "HENRY:模組共有",g_cnt,"筆資料"

END FUNCTION

#載入資料庫中同模組的程式資料
FUNCTION p_thousand_prog_fill(p_pcm)   

   DEFINE p_pcm   LIKE gao_file.gao01   #存放模組別

   #從 程式資料檔(zz_file) 和 程式名稱多語言記錄檔(gaz_file) 載入 程式代號(zz01) 和 程式名稱(gaz03)
   #LET g_sql = "SELECT '',zz01,gaz03 FROM zz_file,gaz_file",
               #" WHERE ", "zz01=gaz01 AND gaz02='",g_lang,"' AND zz011=UPPER('",p_pcm,
               #"') ORDER BY zz01"

   LET g_sql= "SELECT DISTINCT '',gav01,gaz03 ",
              "FROM gav_file LEFT JOIN gaz_file ON gav01 = gaz01 AND gaz02 ='",g_lang,"' ",
              "WHERE  gav01 LIKE LOWER('",p_pcm,"%') ",
              "ORDER BY gav01"
   #DISPLAY "g_sql = ",g_sql
   PREPARE p_thousand_prog FROM g_sql
   DECLARE gaz_curs CURSOR FOR p_thousand_prog
   CALL g_prog_tb.clear()
   LET g_cnt = 1
 
   FOREACH gaz_curs INTO g_prog_tb[g_cnt].*
      LET g_prog_tb[g_cnt].choose = "N"
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_prog_tb.deleteElement(g_cnt)
   LET g_cnt =g_cnt-1
   #DISPLAY "HENRY:程式共有",g_cnt,"筆資料"

END FUNCTION

#依據傳入的參數勾選全部的模組和程式
FUNCTION p_thousand_selectAll(p_atmp)   
   DEFINE p_atmp   STRING
   DEFINE l_nox    LIKE type_file.num5   

   IF p_atmp.equals("1") THEN   #"1"表示根據模組
      FOR l_nox=1 TO g_mod_tb.getlength()
         LET  g_mod_tb[l_nox].choose = "Y"
      END FOR
   END IF
   
   IF p_atmp.equals("2") THEN   #"2"表示根據程式
      FOR l_nox=1 TO g_prog_tb.getlength()
         LET  g_prog_tb[l_nox].choose = "Y"
      END FOR
   END IF
END FUNCTION

#依據傳入的參數取消勾選全部的模組和程式
FUNCTION p_thousand_cancelAll(p_atmp)
   DEFINE p_atmp   STRING
   DEFINE l_nox    LIKE type_file.num5  

   IF p_atmp.equals("1") THEN   #"1"表示根據模組
      FOR l_nox=1 TO g_mod_tb.getlength()
         LET g_mod_tb[l_nox].choose = "N"
      END FOR
   END IF

   IF p_atmp.equals("2") THEN   #"2"表示根據程式
      FOR l_nox=1 TO g_prog_tb.getlength()
         LET g_prog_tb[l_nox].choose = "N"
      END FOR
   END IF
END FUNCTION

#執行畫面輸出欄位格式設定檔(gav_file) 和 畫面元件多語言紀錄檔(gae_file)的修改與插入資料
FUNCTION p_thousand_execution(p_ucd,p_ads,p_atmp,p_gav11)   
   DEFINE   p_ucd          LIKE type_file.chr1                      #存放設否更新客製資料的值
   DEFINE   p_ads          LIKE type_file.chr2                      #存放新增屬性設定或移除屬性設定的值
   DEFINE   p_atmp         LIKE type_file.chr3                      #存放根據模組或根據程式的值
   DEFINE   p_gav11        LIKE type_file.chr10                     #存放行業別

   DEFINE   l_m_cnt        LIKE type_file.num5                      #記錄模組筆數
   DEFINE   l_p_cnt        LIKE type_file.num5                      #記錄程式筆數
   DEFINE   l_a_cnt        LIKE type_file.num5                      #記錄屬性筆數
   DEFINE   l_cnt1         LIKE type_file.num10                     #記錄標準畫面資料的筆數
   # DEFINE   l_cnt1_tmp     LIKE type_file.num10                   #累加至l_cnt1
   DEFINE   l_attr_str     STRING                                   #存放組合過後的屬性字串
   DEFINE   l_attr_str_tmp STRING                                   #暫存存放組合過後的屬性字串
   DEFINE   l_cnt2         LIKE type_file.num10                     #記錄客製l_gae_cnt筆數
   DEFINE   l_gae_cnt      LIKE type_file.num5                      #記錄客製畫面資料的欄位顯示名稱的筆數
   DEFINE   l_gav_tmp      DYNAMIC ARRAY OF RECORD LIKE gav_file.*  #存放gav_file和gae_file結合後的gav_file資料

   DEFINE   l_gav_test      RECORD LIKE gav_file.*  
   
   DEFINE   l_gae_tmp      DYNAMIC ARRAY OF RECORD LIKE gae_file.*  #存放gav_file和gae_file結合後的gae_file資料
   DEFINE   l_gav06_amt    base.StringTokenizer                     #存放加gav06的字串作token
   DEFINE   l_nexttoken    STRING                                   #存放gav06的nexttoken的字串
   DEFINE   l_rate_tmp     STRING                                   #存放"rate()..."的字串
   DEFINE   l_gav06_tmp    STRING                                   #串連l_nexttoken的字串之用
   DEFINE   l_gav06_flag   LIKE type_file.chr1                      #判斷token的字串有無amt之用
   DEFINE   l_gae04_buffer   base.StringBuffer                      #存放字串進行取代功能用
   DEFINE   l_gaq07_tmp    DYNAMIC ARRAY OF RECORD 
               gaq07          LIKE gaq_file.gaq07
                           END RECORD
   DEFINE   g_forupd_sql   STRING

   LET l_m_cnt = 1
   LET l_p_cnt = 1
   CALL g_prog_id.clear()
   LET l_attr_str = ""
   
   ###START###將要處理的程式載入g_prog_id###
   IF p_atmp = "1" THEN   #"1"表示根據模組,將所選模組的程式資料載入g_prog_id的ARRAY OF RECORD
      #DISPLAY "HENRY:根據模組:",p_atmp
      FOR l_m_cnt = 1 TO g_mod_tb.getLength()
         IF g_mod_tb[l_m_cnt].choose = "Y" THEN

            #LET g_sql = "SELECT zz01,gaz03 FROM zz_file,gaz_file",
                        #" WHERE ", "zz01=gaz01 AND gaz02='",g_lang,"' AND zz011='",g_mod_tb[l_m_cnt].gao01,
                        #"' ORDER BY zz01"
                        
            LET g_sql = "SELECT DISTINCT gav01,'' FROM gav_file WHERE gav01 LIKE LOWER('",g_mod_tb[l_m_cnt].gao01,"%')",
                        " ORDER BY gav01"
           
            #DISPLAY "HENRY:q_sql=",g_sql
            PREPARE p_thousand_prog_atm FROM g_sql
            DECLARE gaz_curs_atm CURSOR FOR p_thousand_prog_atm
            
            FOREACH gaz_curs_atm INTO g_prog_id[l_p_cnt].*
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                  EXIT FOREACH
               END IF
               LET l_p_cnt = l_p_cnt + 1
            END FOREACH
            
         END IF
      END FOR
      CALL g_prog_id.deleteElement(l_p_cnt)
      LET l_p_cnt =l_p_cnt-1
      #DISPLAY "HENRY:已選擇的程式共有",l_p_cnt,"筆資料"
      
   END IF

   IF p_atmp = "2" THEN   #"2"表示根據程式,將所選的程式資料載入g_prog_id的ARRAY OF RECORD
      #DISPLAY "HENRY:根據程式",p_atmp
      FOR l_p_cnt = 1 TO g_prog_tb.getLength()
         IF g_prog_tb[l_p_cnt].choose = "Y" THEN
            CALL g_prog_id.appendElement()
            LET g_prog_id[g_prog_id.getLength()].gaz01 = g_prog_tb[l_p_cnt].gaz01
            LET g_prog_id[g_prog_id.getLength()].gaz03 = g_prog_tb[l_p_cnt].gaz03
         END IF
      END FOR
      #DISPLAY "HENRY:已選擇的程式共有",g_prog_id.getLength(),"筆資料"
   END IF
   
   ###END###將要處理的程式載入g_prog_id###

   ###START###將要處理的屬性組合至l_attr_str###
   FOR l_a_cnt = 1 TO g_attr_tb.getLength()
      LET l_attr_str = l_attr_str ,"'",g_attr_tb[l_a_cnt].gck01,"',"
   END FOR
   
   LET l_attr_str=l_attr_str.subString(1,l_attr_str.getLength()-1)
   #DISPLAY "HENRY:已選擇的屬性為",l_attr_str
   ###END###將要處理的屬性組合至l_attr_str###
   
   LET l_p_cnt = 1
   LET l_a_cnt = 1
   LET l_cnt1 = 0
   # LET l_cnt1_tmp = 0
   CALL g_prog_nu.clear()
   CALL g_prog_err.clear()
   CALL g_prog_ud.clear()
   
   IF g_prog_id.getLength()>0 THEN
      CALL cl_progress_bar(g_prog_id.getLength())
   END IF
   
   FOR l_p_cnt = 1 TO g_prog_id.getLength()   #第一層FOR迴圈用程式名稱去處理

      IF g_prog_id.getLength()>0 THEN  
      CALL cl_progressing("Processing Data")
      END IF
      
      LET l_cnt1 = 0
      # FOR l_a_cnt = 1 TO g_attr_tb.getLength()   #第二層FOR迴圈用屬性名稱去處理

      
      #判斷標準畫面資料筆數
      #LET g_sql = "SELECT COUNT(*) FROM gav_file INNER JOIN  gae_file ON gae01=gav01",
                  #" AND gae11=gav08 AND gae02=gav02 AND gae03='",g_lang,"' AND gae12=gav11",
                  #" WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                  #"AND gae04 IN (",l_attr_str,")"

      IF p_gav11 = "all" THEN #如果有行業別選擇all，則忽略"AND gav11='",p_gav11,"' "的WHERE條件
         LET g_sql = "SELECT COUNT(*) FROM gav_file INNER JOIN  gaq_file ",
                     "ON gaq01=gav02 AND gaq02='",g_lang,"'" ,
                     "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                     "AND gaq07 IN (",l_attr_str,")"
      ELSE
         LET g_sql = "SELECT COUNT(*) FROM gav_file INNER JOIN  gaq_file ",
                     "ON gaq01=gav02 AND gaq02='",g_lang,"'" ,
                     "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                     "AND gav11='",p_gav11,"' ",
                     "AND gaq07 IN (",l_attr_str,")"
      END IF



      #DISPLAY "g_sql",g_sql
      
      PREPARE p_thousand_attr_cnt1 FROM g_sql
      EXECUTE p_thousand_attr_cnt1 INTO l_cnt1   #標準畫面資料筆數存入l_cnt1
         
      # DISPLAY "HENRY:[",g_prog_id[l_p_cnt].gaz01,
      # "]的屬性",l_attr_str,"共有",l_cnt1,"筆標準畫面資料"
         
      IF l_cnt1 = 0 THEN   #若l_cnt1=0,表示沒有標準畫面資料,將程式資料載入未更新的程式的清單
         CALL g_prog_nu.appendElement()
         LET g_prog_nu[g_prog_nu.getLength()].gaz01 = g_prog_id[l_p_cnt].gaz01
         LET g_prog_nu[g_prog_nu.getLength()].gaz03 = g_prog_id[l_p_cnt].gaz03

         CALL g_prog_err.appendElement()
         LET g_prog_err[g_prog_err.getLength()].gaz01 = g_prog_id[l_p_cnt].gaz01
         SELECT gaz03 INTO g_prog_err[g_prog_err.getLength()].gaz03 FROM gaz_file 
            WHERE gaz01=g_prog_id[l_p_cnt].gaz01 AND gaz02=g_lang
         LET g_prog_err[g_prog_err.getLength()].gck02 = "所選所有屬性"
         IF p_ucd = 'N' THEN
         LET g_prog_err[g_prog_err.getLength()].err   = "此程式無標準資料畫面，故不處理"
         END IF

         IF p_ucd = 'Y' THEN
         LET g_prog_err[g_prog_err.getLength()].err   = "此程式無客製資料畫面，故不處理"
         END IF

         #DISPLAY "HENRY:",g_prog_id[l_p_cnt].gaz01,"載入未更新的程式清單xxxxxx"
      END IF

      IF l_cnt1 > 0 THEN   #若l_cnt1>0,有標準畫面資料
      
         #DISPLAY "HENRY:",g_prog_id[l_p_cnt].gaz01,"此程式需要更新oooooo"
         
         IF p_ads = "1" THEN   #"1"表示勾選新增屬性設定
            #IF p_ucd = "Y" THEN   #若勾選更新客製資料
            
# START ############## gav06在適當位子要加上amt的字串 #############################
            LET l_attr_str_tmp = l_attr_str
            #取出客製畫面資料對gav06加上amt的字串，然後更新至資料庫
            #LET g_sql = "SELECT gav_file.*,gae04 FROM gav_file INNER JOIN  gae_file ON gae01=gav01",
                        #" AND gae11=gav08 AND gae02=gav02 AND gae03='",g_lang,"' AND gae12=gav11",
                        #" WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                        #"AND gae04 IN (",l_attr_str_tmp,")"
                        
            IF p_gav11 = "all" THEN #如果有行業別選擇all，則忽略"AND gav11='",p_gav11,"' "的WHERE條件
               LET g_sql = "SELECT gav_file.*,gaq07 FROM gav_file INNER JOIN  gaq_file ",
                           "ON gaq01=gav02 AND gaq02='",g_lang,"' ",
                           "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                           "AND gaq07 IN (",l_attr_str_tmp,")"
            ELSE
               LET g_sql = "SELECT gav_file.*,gaq07 FROM gav_file INNER JOIN  gaq_file ",
                           "ON gaq01=gav02 AND gaq02='",g_lang,"' ",
                           "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                           "AND gav11='",p_gav11,"' ",
                           "AND gaq07 IN (",l_attr_str_tmp,")"
            END IF



            #DISPLAY "g_sql",g_sql
            
            PREPARE p_ads_1_p_ucd_y_c FROM g_sql
            DECLARE p_ads_1_p_ucd_y_c_curs CURSOR FOR p_ads_1_p_ucd_y_c
            #DISPLAY "HENRY:g_sql =",g_sql
            CALL l_gav_tmp.clear()
            CALL l_gaq07_tmp.clear()
            LET g_cnt = 1
   
            LET l_gae04_buffer = base.StringBuffer.create()
            CALL l_gae04_buffer.append(l_attr_str_tmp)
   
            FOREACH p_ads_1_p_ucd_y_c_curs INTO l_gav_tmp[g_cnt].*,l_gaq07_tmp[g_cnt].gaq07
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                  #DISPLAY "HENRY:g_sql =",g_sql
                  #DISPLAY "LOCK LOCK LOCK"
                  EXIT FOREACH
               END IF

               LET l_gav06_flag = "0"
               LET l_gav06_tmp = ""

               ### start ### 判斷要加入'amt'字串的規則 ###
               IF NOT l_gav_tmp[g_cnt].gav06 IS NULL THEN   #對gav06加入amt的字串
                  LET l_gav06_amt = base.StringTokenizer.create(l_gav_tmp[g_cnt].gav06, "|")

                  WHILE l_gav06_amt.hasMoreTokens()   #對gav06的字串作token的判斷

                     LET l_nexttoken = l_gav06_amt.nextToken()

                     IF l_nexttoken.getIndexOf("rate(",1) != 0  THEN
                        #DISPLAY "HENRY:",l_nexttoken
                        LET l_gav06_flag = "2"   #表示gav06的字串內含有'rate('字串
                        #DISPLAY "HENRY:此字串含有'rate':",l_gav06_flag
                     END IF

                     IF l_nexttoken = "amt" THEN
                        #DISPLAY "HENRY:",l_nexttoken
                        LET l_gav06_flag = "1"   #表示gav06的字串內含有'amt'字串
                        #DISPLAY "HENRY:此字串含有'amt':",l_gav06_flag
                     END IF

                     IF l_nexttoken.getIndexOf("show_fd_desc",1) != 0  THEN
                        #DISPLAY "HENRY:",l_nexttoken
                        LET l_gav06_flag = "3"   #表示gav06的字串內含有'show_fd_desc'字串
                        #DISPLAY "HENRY:此字串含有'show_fd_desc':",l_gav06_flag
                     END IF

                     IF l_nexttoken.getIndexOf("show_itme(",1) != 0  THEN
                        #DISPLAY "HENRY:",l_nexttoken
                        LET l_gav06_flag = "4"   #表示gav06的字串內含有'show_itme('字串
                        #DISPLAY "HENRY:此字串含有'show_itme(':",l_gav06_flag
                     END IF

                     LET l_gav06_tmp = l_gav06_tmp,l_nexttoken,"|"
                  END WHILE

                  #DISPLAY "HENRY:################################"
                  LET l_gav06_tmp = l_gav06_tmp.subString(1,l_gav06_tmp.getLength()-1)
                  
                  IF l_gav06_flag = "0" THEN   #表示gav06的字串不含有amt字串,則加入amt字串至最前面
                     #DISPLAY "HENRY:",l_gav06_flag,l_gav06_flag,l_gav06_flag
                     LET l_gav06_tmp = "amt|",l_gav06_tmp
                     #LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp

                     LET g_forupd_sql = "SELECT * FROM gav_file ",
                                        " WHERE gav01 = '",l_gav_tmp[g_cnt].gav01,
                                        "' AND gav02 = '",l_gav_tmp[g_cnt].gav02 ,
                                        "' AND gav08 = '",l_gav_tmp[g_cnt].gav08 ,
                                        "' AND gav11 = '",l_gav_tmp[g_cnt].gav11,"' FOR UPDATE"
                     LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
                     PREPARE p_thousand_update FROM  g_forupd_sql
                     EXECUTE p_thousand_update
                     #DISPLAY "SQLCA.SQLCODE,STATUS",SQLCA.SQLCODE,STATUS
                                        
                     IF SQLCA.SQLCODE THEN
                        #DISPLAY "資料被鎖住",SQLCA.SQLCODE,STATUS
                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang
                           
                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang

                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                        
                        #LET g_prog_ud[g_prog_ud.getLength()].ac = "此筆資料Locking，故不處理"
                        LET g_prog_ud[g_prog_ud.getLength()].ac = "Data locking"

                        LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     ELSE
                        #DISPLAY "資料沒有被鎖住",SQLCA.SQLCODE,STATUS
                        LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                        
                        UPDATE gav_file SET gav06 = l_gav_tmp[g_cnt].gav06   #將處理後的gav06字串更新至資料庫
                           WHERE gav01=l_gav_tmp[g_cnt].gav01 
                           AND gav02=l_gav_tmp[g_cnt].gav02
                           AND gav08=l_gav_tmp[g_cnt].gav08 
                           AND gav11=l_gav_tmp[g_cnt].gav11
                           
                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang

                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
   
                       #LET g_prog_ud[g_prog_ud.getLength()].ac = "加入amt字串至首位"
                       LET g_prog_ud[g_prog_ud.getLength()].ac = "Added 'amt' to the first" 
                       LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     END IF
                     
                  END IF

                  #IF l_gav06_flag = "1" THEN   #表示gav06的字串內含有'amt'字串，不再加入'amt'的字串
                     #CALL g_prog_ud.appendElement()
                     #LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     #
                     #SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        #WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang
#
                     #LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     #
                     #SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        #WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
#
                     #SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        #WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        #
                     #LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                     #LET g_prog_ud[g_prog_ud.getLength()].ac   = "原本就有amt,故不處理"
                     #LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                  #END IF

                  IF l_gav06_flag = "2" THEN   #表示gav06的字串內含有'rate('字串，加入'amt'的字串至第二順位
                     LET l_gav06_amt = base.StringTokenizer.create(l_gav06_tmp, "|")
                     LET l_gav06_tmp = ""
                     WHILE l_gav06_amt.hasMoreTokens()
                        LET l_nexttoken = l_gav06_amt.nextToken()
                        IF l_nexttoken.getIndexOf("rate(",1) != 0  THEN
                           LET l_nexttoken = l_nexttoken,"|amt"
                        END IF
                        LET l_gav06_tmp = l_gav06_tmp,l_nexttoken,"|"
                     END WHILE 
                     LET l_gav06_tmp = l_gav06_tmp.subString(1,l_gav06_tmp.getLength()-1)
                     #LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                     
                     LET g_forupd_sql = "SELECT * FROM gav_file ",
                                        " WHERE gav01 = '",l_gav_tmp[g_cnt].gav01,
                                        "' AND gav02 = '",l_gav_tmp[g_cnt].gav02 ,
                                        "' AND gav08 = '",l_gav_tmp[g_cnt].gav08 ,
                                        "' AND gav11 = '",l_gav_tmp[g_cnt].gav11,"' FOR UPDATE"
                     LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
                     PREPARE p_thousand_update_1 FROM  g_forupd_sql
                     EXECUTE p_thousand_update_1
                     #DISPLAY "SQLCA.SQLCODE,STATUS",SQLCA.SQLCODE,STATUS
                                        
                     IF SQLCA.SQLCODE THEN
                        #DISPLAY "資料被鎖住",SQLCA.SQLCODE,STATUS
                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                     
                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                     
                        #LET g_prog_ud[g_prog_ud.getLength()].ac   = "此筆資料Locking，故不處理"
                        LET g_prog_ud[g_prog_ud.getLength()].ac   = "Data locking"
                        LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     ELSE
                        #DISPLAY "資料沒有被鎖住",SQLCA.SQLCODE,STATUS
                        LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                        UPDATE gav_file SET gav06 = l_gav_tmp[g_cnt].gav06   #將處理後的gav06字串更新至資料庫
                           WHERE gav01=l_gav_tmp[g_cnt].gav01 
                           AND gav02=l_gav_tmp[g_cnt].gav02
                           AND gav08=l_gav_tmp[g_cnt].gav08 
                           AND gav11=l_gav_tmp[g_cnt].gav11

                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                           
                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                       
                        #LET g_prog_ud[g_prog_ud.getLength()].ac = "加入'amt'的字串至次位"
                        LET g_prog_ud[g_prog_ud.getLength()].ac = "Added 'amt' to the second"
                        LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     END IF
                  END IF

                  IF l_gav06_flag = "3" THEN   #表示gav06的字串內含有'show_fd_desc'字串，與'amt'字串互斥，不再加入'amt'的字串
                     CALL g_prog_ud.appendElement()
                     LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                     LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                    
                     SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                     LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                    
                     #LET g_prog_ud[g_prog_ud.getLength()].ac   = "原本就有show_fd_desc,故不處理(互斥)"
                     LET g_prog_ud[g_prog_ud.getLength()].ac   = "'show_fd_desc' existed(exclusive)"
                     LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06                        
                  END IF

                  IF l_gav06_flag = "4" THEN   #表示gav06的字串內含有'show_itme('字串，與'amt'字串互斥，不再加入'amt'的字串
                     CALL g_prog_ud.appendElement()
                     LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                     LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                        
                     SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                     LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"

                     #LET g_prog_ud[g_prog_ud.getLength()].ac   = "原本就有show_itme,故不處理(互斥)"
                     LET g_prog_ud[g_prog_ud.getLength()].ac   = "'show_itme' existed(exclusive)"
                     LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06                        
                  END IF

                  #DISPLAY "HENRY:$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                  
                  #LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                  
               ELSE   #l_gav_tmp[g_cnt].gav06為null,則直接加入amt字串
                  #LET l_gav_tmp[g_cnt].gav06 = "amt"
                  
                  LET g_forupd_sql = "SELECT * FROM gav_file ",
                                     " WHERE gav01 = '",l_gav_tmp[g_cnt].gav01,
                                     "' AND gav02 = '",l_gav_tmp[g_cnt].gav02 ,
                                     "' AND gav08 = '",l_gav_tmp[g_cnt].gav08 ,
                                     "' AND gav11 = '",l_gav_tmp[g_cnt].gav11,"' FOR UPDATE"
                  LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
                  PREPARE p_thousand_update_2 FROM  g_forupd_sql
                  EXECUTE p_thousand_update_2
                  #DISPLAY "SQLCA.SQLCODE,STATUS",SQLCA.SQLCODE,STATUS
                                        
                  IF SQLCA.SQLCODE THEN
                     #DISPLAY "資料被鎖住",SQLCA.SQLCODE,STATUS
                     CALL g_prog_ud.appendElement()
                     LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                     LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang

                     SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                     LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                        
                     #LET g_prog_ud[g_prog_ud.getLength()].ac   = "此筆資料Locking，故不處理"
                     LET g_prog_ud[g_prog_ud.getLength()].ac   = "Data locking"
                     LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06 
                  ELSE
                     #DISPLAY "資料沒有被鎖住",SQLCA.SQLCODE,STATUS
                     LET l_gav_tmp[g_cnt].gav06 = "amt"
                     UPDATE gav_file SET gav06 = l_gav_tmp[g_cnt].gav06   #將處理後的gav06字串更新至資料庫
                        WHERE gav01=l_gav_tmp[g_cnt].gav01 
                        AND gav02=l_gav_tmp[g_cnt].gav02
                        AND gav08=l_gav_tmp[g_cnt].gav08 
                        AND gav11=l_gav_tmp[g_cnt].gav11
                     CALL g_prog_ud.appendElement()
                     LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                     LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang

                     SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                     LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                   
                     #LET g_prog_ud[g_prog_ud.getLength()].ac = "為null,則直接加入amt字串"
                     LET g_prog_ud[g_prog_ud.getLength()].ac = "Added 'amt'"

                     LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                  END IF
               END IF
               ### end ### 判斷要加入'amt'字串的規則 ###

               #CALL l_gae04_buffer.replace(l_gae04_tmp[g_cnt].gae04,"@@@",0)

               LET g_cnt = g_cnt + 1
            END FOREACH
            
            CALL l_gav_tmp.deleteElement(g_cnt)
            LET g_cnt =g_cnt-1
            #DISPLAY "共更新",g_cnt,"筆資料"
# END ########### gav06在適當位子要加上amt的字串 #############################


            
# START ########### 若無客製資料則取標準資料新增客製資料 #############################
            #LET l_attr_str_tmp=l_gae04_buffer.toString()
            #DISPLAY "HENRY:標準資料屬性=",l_attr_str_tmp
            #
            #取出標準畫面資料,新增客製資料至資料庫,其gav08=“Y”,且gav06要加上amt的字串(要考慮分隔符號|)
            #LET g_sql = "SELECT gav_file.*,gae_file.* FROM gav_file INNER JOIN  gae_file ON gae01=gav01",
                        #" AND gae11=gav08 AND gae02=gav02 AND gae03='",g_lang,"' AND gae12=gav11",
                        #" WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='N' ",
                        #"AND gae04 IN (",l_attr_str_tmp,")"
            #PREPARE p_ads_1_p_ucd_y_s FROM g_sql
            #DECLARE p_ads_1_p_ucd_y_s_curs CURSOR FOR p_ads_1_p_ucd_y_s
            #DISPLAY "HENRY:g_sql =",g_sql
            #CALL l_gav_tmp.clear()
            #LET g_cnt = 1

            #FOREACH p_ads_1_p_ucd_y_s_curs INTO l_gav_tmp[g_cnt].*,l_gae_tmp[g_cnt].*
               #IF SQLCA.SQLCODE THEN
                  #CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                  #DISPLAY "HENRY:g_sql =",g_sql
                  #EXIT FOREACH
               #END IF

               #LET l_gav_tmp[g_cnt].gav08="Y"   #將標準畫面資料轉為客製畫面資料
               #LET l_gae_tmp[g_cnt].gae11 = "Y"   #將標準畫面資料對應的屬性值轉為客製畫面資料對應的屬性值

               #INSERT INTO gav_file VALUES(l_gav_tmp[g_cnt].*)   #插入gav_file中的新增的客製資料
               #INSERT INTO gae_file VALUES(l_gae_tmp[g_cnt].*)   #插入gae_file中的新增的客製資料對應的屬性值

               #LET g_cnt = g_cnt + 1
            #END FOREACH
            #CALL l_gav_tmp.deleteElement(g_cnt)
            #LET g_cnt =g_cnt-1
# END ########### 若無客製資料則新增且gav06要加上amt的字串 #############################
         
         END IF


         IF p_ads = "2" THEN   #"2"表示勾選刪除屬性設定
               #取出客製畫面資料對gav06去除amt的字串，然後更新至資料庫
               #LET g_sql = "SELECT gav_file.*,gae04 FROM gav_file INNER JOIN  gae_file ON gae01=gav01",
                           #" AND gae11=gav08 AND gae02=gav02 AND gae03='",g_lang,"' AND gae12=gav11",
                           #" WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                           #"AND gae04 IN (",l_attr_str,")"

               IF p_gav11 = "all" THEN #如果有行業別選擇all，則忽略"AND gav11='",p_gav11,"' "的WHERE條件
                  LET g_sql = "SELECT gav_file.*,gaq07 FROM gav_file INNER JOIN  gaq_file ",
                           "ON gaq01=gav02 AND gaq02='",g_lang,"' ",
                           "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                           "AND gaq07 IN (",l_attr_str,")"
               ELSE
                  LET g_sql = "SELECT gav_file.*,gaq07 FROM gav_file INNER JOIN  gaq_file ",
                           "ON gaq01=gav02 AND gaq02='",g_lang,"' ",
                           "WHERE gav01='",g_prog_id[l_p_cnt].gaz01,"' AND gav08='",p_ucd,"' ",
                           "AND gav11='",p_gav11,"' ",
                           "AND gaq07 IN (",l_attr_str,")"
               END IF


               #DISPLAY "g_sql",g_sql
                        
               PREPARE p_ads_2_p_ucd_y_c FROM g_sql
               DECLARE p_ads_2_p_ucd_y_c_curs CURSOR FOR p_ads_2_p_ucd_y_c
               #DISPLAY "HENRY:g_sql =",g_sql
               CALL l_gav_tmp.clear()
               CALL l_gaq07_tmp.clear()
               LET g_cnt = 1


               FOREACH p_ads_2_p_ucd_y_c_curs INTO l_gav_tmp[g_cnt].*,l_gaq07_tmp[g_cnt].gaq07
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err('foreach:',SQLCA.SQLCODE,1)
                     #DISPLAY "HENRY:g_sql =",g_sql
                     EXIT FOREACH
                  END IF

                  LET l_gav06_flag = "5"
                  LET l_gav06_tmp = ""

                  IF NOT l_gav_tmp[g_cnt].gav06 IS NULL THEN   #對gav06去除amt的字串
                     #DISPLAY "HENRY:l_gav_tmp[g_cnt].gav06=",l_gav_tmp[g_cnt].gav06
                     LET l_gav06_amt = base.StringTokenizer.create(l_gav_tmp[g_cnt].gav06, "|")

                     WHILE l_gav06_amt.hasMoreTokens()
                        LET l_nexttoken = l_gav06_amt.nextToken()
                        IF l_nexttoken != "amt" THEN
                           LET l_gav06_tmp = l_gav06_tmp,l_nexttoken,"|"
                        ELSE
                           LET l_gav06_flag = "6"
                        END IF
                     END WHILE

                     LET l_gav06_tmp = l_gav06_tmp.subString(1,l_gav06_tmp.getLength()-1)
                     #LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                  END IF
                  
                  IF    l_gav06_flag = "6" THEN
                     #DISPLAY "HENRY:l_gav06_flag=",l_gav06_flag
                     
                     LET g_forupd_sql = "SELECT * FROM gav_file ",
                                        " WHERE gav01 = '",l_gav_tmp[g_cnt].gav01,
                                        "' AND gav02 = '",l_gav_tmp[g_cnt].gav02 ,
                                        "' AND gav08 = '",l_gav_tmp[g_cnt].gav08 ,
                                        "' AND gav11 = '",l_gav_tmp[g_cnt].gav11,"' FOR UPDATE"
                     LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
                     PREPARE p_thousand_update_3 FROM  g_forupd_sql
                     EXECUTE p_thousand_update_3
                     #DISPLAY "SQLCA.SQLCODE,STATUS",SQLCA.SQLCODE,STATUS
                                          
                     IF SQLCA.SQLCODE THEN
                        #DISPLAY "資料被鎖住",SQLCA.SQLCODE,STATUS
                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                           
                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                           
                        #LET g_prog_ud[g_prog_ud.getLength()].ac   = "此筆資料Locking，故不處理"
                        LET g_prog_ud[g_prog_ud.getLength()].ac   = "Data locking"

                        LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     ELSE
                        #DISPLAY "資料沒有被鎖住",SQLCA.SQLCODE,STATUS
                        LET l_gav_tmp[g_cnt].gav06 = l_gav06_tmp
                        
                        UPDATE gav_file SET gav06 = l_gav_tmp[g_cnt].gav06   #將處理後的gav06字串更新至資料庫
                           WHERE gav01=l_gav_tmp[g_cnt].gav01 
                           AND gav02=l_gav_tmp[g_cnt].gav02
                           AND gav08=l_gav_tmp[g_cnt].gav08 
                           AND gav11=l_gav_tmp[g_cnt].gav11
                           
                        CALL g_prog_ud.appendElement()
                        LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                        SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                           WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang

                        LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                        SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                           WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                           
                        SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                           WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                        LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
                           
                        #LET g_prog_ud[g_prog_ud.getLength()].ac = "除去amt字串"
                        LET g_prog_ud[g_prog_ud.getLength()].ac = "Remove 'amt'"

                        LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                     END IF
                  END IF

                  #IF    l_gav06_flag = "5" THEN
                     #DISPLAY "HENRY:l_gav06_flag=",l_gav06_flag
                     #CALL g_prog_ud.appendElement()
                     #LET g_prog_ud[g_prog_ud.getLength()].gaz01 = l_gav_tmp[g_cnt].gav01
                     #SELECT gaz03 INTO g_prog_ud[g_prog_ud.getLength()].gaz03 FROM gaz_file 
                        #WHERE gaz01=l_gav_tmp[g_cnt].gav01 AND gaz02=g_lang
#
                     #LET g_prog_ud[g_prog_ud.getLength()].gaq01 = l_gav_tmp[g_cnt].gav02
                     #SELECT gaq03 INTO g_prog_ud[g_prog_ud.getLength()].gaq03 FROM gaq_file
                        #WHERE gaq01 = l_gav_tmp[g_cnt].gav02 AND gaq02=g_lang
                     #
                     #SELECT gck02 INTO g_prog_ud[g_prog_ud.getLength()].gck02 FROM gck_file
                        #WHERE gck01 = l_gaq07_tmp[g_cnt].gaq07
                     #LET g_prog_ud[g_prog_ud.getLength()].gck02 = l_gaq07_tmp[g_cnt].gaq07,"(",g_prog_ud[g_prog_ud.getLength()].gck02,")"
#
                     #LET g_prog_ud[g_prog_ud.getLength()].ac   = "原本就無amt,故不處理"
                     #LET g_prog_ud[g_prog_ud.getLength()].result = l_gav_tmp[g_cnt].gav06
                  #END IF

                  LET g_cnt = g_cnt + 1
               END FOREACH
               
               CALL l_gav_tmp.deleteElement(g_cnt)
               LET g_cnt =g_cnt-1
            
         END IF
         
      END IF

   END FOR
   
END FUNCTION

#將 每個欄位的處理清單(g_prog_ud) 擷取簡化成 每隻程式的處理清單(g_prog_list)
FUNCTION p_thousand_updatedList()
   DEFINE   l_nox    LIKE type_file.num5
   DEFINE   l_noy    LIKE type_file.num5
   DEFINE   l_tmp   DYNAMIC ARRAY OF RECORD   #存放處理程式清單
               gaz01         LIKE gaz_file.gaz01   #模組別
            END RECORD

   #g_prog_ud     DYNAMIC ARRAY OF RECORD   存放已更新的欄位和程式的資料
   CALL l_tmp.appendElement()
   LET l_tmp[1].gaz01 = g_prog_ud[1].gaz01
   #DISPLAY "l_tmp[1].gaz01 = ",l_tmp[1].gaz01
   
   CALL g_prog_list.appendElement()

   SELECT zz011 INTO g_prog_list[g_prog_list.getLength()].gao01 FROM zz_file 
      WHERE zz01=g_prog_ud[1].gaz01
      
   LET g_prog_list[g_prog_list.getLength()].gaz01 = g_prog_ud[1].gaz01
   LET g_prog_list[g_prog_list.getLength()].gaz03 = g_prog_ud[1].gaz03

   FOR l_nox=1 TO g_prog_ud.getlength()

   
      FOR l_noy=1 TO l_tmp.getLength()
         IF g_prog_ud[l_nox].gaz01 != l_tmp[l_noy].gaz01 THEN

            #CALL l_tmp.appendElement()
            LET l_tmp[l_tmp.getLength()].gaz01 = g_prog_ud[l_nox].gaz01
            #DISPLAY "l_tmp[l_tmp.getLength()].gaz01 = ",l_tmp[l_tmp.getLength()].gaz01
            #DISPLAY "l_tmp.getLength() = ",l_tmp.getLength()
            LET l_tmp[1].gaz01=g_prog_ud[l_nox].gaz01

            CALL g_prog_list.appendElement()
            SELECT zz011 INTO g_prog_list[g_prog_list.getLength()].gao01 FROM zz_file 
               WHERE zz01=g_prog_ud[l_nox].gaz01
            LET g_prog_list[g_prog_list.getLength()].gaz01 = g_prog_ud[l_nox].gaz01
            LET g_prog_list[g_prog_list.getLength()].gaz03 = g_prog_ud[l_nox].gaz03
            
         END IF
      END FOR

      
   END FOR

END FUNCTION

FUNCTION p_thousand_set_combo_industry(pc_fieldname)
   DEFINE   pc_fieldname STRING
   DEFINE   ls_sql       STRING
   DEFINE   lc_smb01     LIKE smb_file.smb01
   DEFINE   lc_smb03     LIKE smb_file.smb03
   DEFINE   ls_value     STRING
   DEFINE   ls_desc      STRING

   LET ls_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
   PREPARE smb_pre FROM ls_sql
   DECLARE smb_curs CURSOR FOR smb_pre
   FOREACH smb_curs INTO lc_smb01,lc_smb03
      IF lc_smb01 = "std" THEN
         LET ls_value = lc_smb01 CLIPPED,",",ls_value
         LET ls_desc = lc_smb01 CLIPPED," : ",lc_smb03 CLIPPED,",",ls_desc
      ELSE
         LET ls_value = ls_value,lc_smb01 CLIPPED,","
         LET ls_desc = ls_desc,lc_smb01 CLIPPED," : ",lc_smb03 CLIPPED,","
      END IF
   END FOREACH

   #DISPLAY "ls_value = ",ls_value
   #DISPLAY "ls_desc = ",ls_desc
   LET ls_value = ls_value,"all,"
   LET ls_desc = ls_desc,"all : All industries,"
   
   CALL cl_set_combo_items(pc_fieldname,ls_value.subString(1,ls_value.getLength()-1),
   ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
