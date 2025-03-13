# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_create_schema.4gl
# Descriptions...: 建立Schema
# Date & Author..: 09/11/02 By Hiko
# Modify.........: No.FUN-9B0012 09/11/02 By Hiko
# Memo...........: 有用5個專屬資料庫的Table:all_users,user_synonyms,user_tables,user_views,V$SESSION
# Modify.........: FUN-A10073 10/01/14 By Hiko dba_users改成all_users
# Modify.........: FUN-9C0157 10/01/19 By Hiko 1.createdb更名為createsch 2.將log檔名再加上日期 3.行業別改為預設azw03 4.執行結束後,要顯現有ERROR的log檔名
# Modify.........: FUN-A10121 10/01/22 By Hiko 因為aooi931在離開前的檢查改為CALL p_create_schema_prep(),因此p_create_schema()不需要再回傳了.
# Modify.........: FUN-A20015 10/02/04 By tommas 虛擬Schema建立view前,要先將來源Table的xxxplant建立index.
# Modify.........: FUN-A30007 10/03/01 By Hiko 將ods的Schema清單取得SQL改為FUNCTION,可讓p_zta共用.
# Modify.........: FUN-A30088 10/03/25 By Hiko 1.初始化公用變數 2.調整FGL_GETRESOURCE的取得
# Modify.........: FUN-A40004 10/04/01 By Hiko 1.調整SESSIONID的取得方式 
# Modify.........:                             2.調整ods資料庫清單的取得方式
# Modify.........: FUN-A50080 10/05/20 By Hiko 1.標準架構取消營運中心階層,移除屬於azwa_file的設定
# Modify.........:                             2.Table清單不要與gat_file勾稽,單純以zta_file為主.
# Modify.........: FUN-A70028 10/05/25 By Hiko SQL Server版本調整:a.SQL SERVER不用GRANT 
# Modify.........:                                                b.只需檢查登入資料庫的使用者與密碼即可
# Modify.........:                                                c.畫面也有所不同:增加SQL Server專用頁籤(Page3),並增加5個欄位:ed_msv_user,ed_msv_psw,ed_msv_sch,ed_msv_ref_sch,chk_msv_demo
# Modify.........:                                                d.移除FUNCTION p_create_schema_ods_sch_sql():因為p_zta不需要共用.
# Modify.........: FUN-A70029 10/07/12 By Kevin SQL Server版本調整:a.修改synonym 執行方法
#                                                                  b.修改view 執行方法
# Modify.........: FUN-A70115 10/07/22 By Kevin 功能加強:1.建立過程progress bar
#                                                        2.可以獨立重跑虛擬DB的View重建(包含重設synonym)
#                                                        3.ods view重建也要包含重設synonym
# Modify.........: FUN-A80140 10/08/27 By Kevin Rebuild virtual DB 使用prepare
# Modify.........: FUN-AA0052 10/10/14 By Jay Sybase版本調整
# Modify.........: FUN-AB0017 10/11/18 By Jay 設定新增schema所在儲存空間
# Modify.........: FUN-B10033 11/01/14 By Jay 簡化檢查 $FGLPROFILE 權限程式
# Modify.........: FUN-B30150 11/03/18 By Jay 先將ed_ora_device欄位隱藏起來
# Modify.........: FUN-B70083 11/07/21 By Jay 功能加強:1.欄位資料default成新營運中心代碼
#                                                     2.行業別參數資料可由user自己選擇要不要匯入
#                                                     3.ods rebuild動作可由user自己選擇要不要做
# Modify.........: FUN-B90135 11/09/28 By Jay 複製完DB後,進行legal和plant欄位的資料更新
# Modify.........: FUN-BB0118 12/01/02 By Jay 1.屬財務模組的table且建立DB不為法人DB時,不做legal&plant code的更新
#                                             2.在重建ods view時增加重建synonym功能
# Modify.........: MOD-C40010 12/04/04 By Vampire 複製完DB增加omb44程式

import os
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-9B0012

DEFINE g_list DYNAMIC ARRAY OF RECORD
              sel            LIKE type_file.chr1,
              legal          LIKE azw_file.azw02,   #法人
              legal_db       LIKE azw_file.azw09,   #法人Schema
              schema         LIKE azw_file.azw06,   #Schema
              ind            LIKE azw_file.azw03,   #行業別
              is_virtual     LIKE type_file.chr1,   #是否為虛擬
              target_schema  LIKE azw_file.azw05,   #目標Schema
              has_built      LIKE type_file.chr1    #是否已建立
              END RECORD
DEFINE tm_arr DYNAMIC ARRAY OF RECORD
              azp03_1        LIKE azp_file.azp03,   #欲產生的資料庫代碼                             
              ed4            LIKE type_file.chr30,  #新資料庫密碼
              ed4_1          LIKE type_file.chr30,  #確認密碼
              azp03_2        LIKE azp_file.azp03,   #參考資料庫代碼
              ed4_9          LIKE type_file.chr30,  #參考資料庫密碼
              ed_ora_device  LIKE type_file.chr20,  #FUN-AB0017    oracle tablespace位置
              demo           LIKE type_file.chr1,   #              產生資料庫是否需有demo data的匯入
              base_data      LIKE type_file.chr1,   #FUN-B70083    p_base_data作業之行業別參數資料是否載入
              ed_msv_sch     LIKE azp_file.azp03,   #FUN-A70028    msv欲產生的資料庫代碼
              ed_msv_ref_sch LIKE azp_file.azp03,   #              msv參考資料庫代碼
              chk_msv_demo   LIKE type_file.chr1,   #              msv產生資料庫是否需有demo data的匯入
              ed_ase_sch     LIKE azp_file.azp03,   #FUN-AA0052    ase欲產生的資料庫代碼
              ed_ase_ref_sch LIKE azp_file.azp03,   #FUN-AA0052    ase參考資料庫代碼
              ed_ase_device  LIKE type_file.chr20,  #FUN-AB0017    ase database device位置
              chk_ase_demo   LIKE type_file.chr1    #FUN-AA0052    ase產生資料庫是否需有demo data的匯入
              #ind           LIKE type_file.chr10   #FUN-9C0157
              END RECORD
DEFINE tm     RECORD
              azp03_1        LIKE azp_file.azp03,                                
              ed4            LIKE type_file.chr30,
              ed4_1          LIKE type_file.chr30,
              azp03_2        LIKE azp_file.azp03,
              ed4_9          LIKE type_file.chr30,
              ed_ora_device  LIKE type_file.chr20,  #FUN-AB0017
              demo           LIKE type_file.chr1,
              base_data      LIKE type_file.chr1,   #FUN-B70083
              ed_msv_sch     LIKE azp_file.azp03,   #FUN-A70028
              ed_msv_ref_sch LIKE azp_file.azp03,
              chk_msv_demo   LIKE type_file.chr1 ,
              ed_ase_sch     LIKE azp_file.azp03,   #FUN-AA0052
              ed_ase_ref_sch LIKE azp_file.azp03,   #FUN-AA0052
              ed_ase_device  LIKE type_file.chr20,  #FUN-AB0017
              chk_ase_demo   LIKE type_file.chr1    #FUN-AA0052  
              #ind           LIKE type_file.chr10   #FUN-9C0157
              END RECORD
DEFINE g_azp03_1 STRING #因為此作業的主體是azp03_1,幾乎每個地方都會用到,所以為了簡化程式,改成global變數.
DEFINE tmpsw RECORD
             ed4_2 LIKE type_file.chr30, #ds密碼
             ed4_4 LIKE type_file.chr30, #system密碼
             ed4_6 LIKE type_file.chr30, #sys密碼
             ods_rebuild LIKE type_file.chr1,  #是否需要重建ods 資料庫 #FUN-B70083    
             ed_msv_user LIKE type_file.chr30, #SQL Server使用者
             ed_msv_psw  LIKE type_file.chr30, #SQL Server密碼 
             ed_ase_user LIKE type_file.chr30, #Sybase使用者         #FUN-AA0052  
             ed_ase_psw  LIKE type_file.chr30  #Sybase密碼           #FUN-AA0052  
             END RECORD
DEFINE g_psw RECORD
             ed4_2 LIKE type_file.chr30, #ds密碼
             ed4_4 LIKE type_file.chr30, #system密碼
             ed4_6 LIKE type_file.chr30, #sys密碼
             ods_rebuild LIKE type_file.chr1,  #是否需要重建ods 資料庫 #FUN-B70083    
             ed_msv_user LIKE type_file.chr30, #SQL Server使用者
             ed_msv_psw  LIKE type_file.chr30, #SQL Server密碼 
             ed_ase_user LIKE type_file.chr30, #Sybase使用者         #FUN-AA0052  
             ed_ase_psw  LIKE type_file.chr30  #Sybase密碼           #FUN-AA0052  
             END RECORD
DEFINE g_tmpdir STRING #$TOP/tmp
#DEFINE g_pid STRING #log檔所需要的辨識用PROCESS ID #FUN-9C0157
DEFINE g_idx SMALLINT
DEFINE g_log_ch base.Channel
DEFINE g_syn_arr  DYNAMIC ARRAY OF RECORD  #虛擬Schema的Synonym清單
                  zta01 LIKE zta_file.zta01,
                  zta09 LIKE zta_file.zta09  #FUN-A70029
                  END RECORD,
       g_view_arr DYNAMIC ARRAY OF LIKE zta_file.zta01 #虛擬Schema的View清單
DEFINE g_today_str STRING #FUN-9C0157
DEFINE g_log_arr DYNAMIC ARRAY OF RECORD #ods的紀錄不包含在這裡.
                 te1 STRING, #today_xxx.log:執行過程記錄,例如100119_ds99.log
                 te2 STRING, #createsch_xxx.log:建立資料庫時的記錄,例如createsch_ds99.log
                 te3 STRING, #imp_xxx.log:匯出參考資料庫時的記錄,例如exp_ds1.log
                 te4 STRING, #exp_xxx.log:匯入新建資料庫時的記錄,例如imp_ds99.log
                 te5 STRING, #today_xxx_syn_legal.log:實體Schema設定Synonym到法人Schema的記錄,例如100119_ds98_syn_legal.log
                 te6 STRING, #today_xxx_load.log:實體Schema載入行業別基本資料的記錄,例如100119_ds99_load.log
                 te7 STRING, #today_xxx_syn.log:虛擬Schema設定Synonym的記錄,例如100119_dsv99_syn.log
                 te8 STRING, #today_xxx_view.log:虛擬Schema建立View的記錄,例如100119_dsv99_view.log
                 te9 STRING  #today_xxx_grant_ods.log:實體Schema設定權限給ods的記錄,例如100119_ds98_grant_ods.log
                 END RECORD
DEFINE g_ods_ch base.Channel
DEFINE g_ods_arr DYNAMIC ARRAY OF LIKE zta_file.zta01 #ods的View清單
DEFINE g_ods_syn DYNAMIC ARRAY OF LIKE zta_file.zta01 #ods的Synonym清單
DEFINE g_sch_arr DYNAMIC ARRAY OF LIKE azw_file.azw05 #為了rebuild_ods_view共用
DEFINE g_db_type STRING  #FUN-A70028 
DEFINE g_msv_user STRING, #FUN-A70028:為了簡化程式,改成global變數.
       g_msv_psw  STRING,
       g_msv_db   STRING  #FUN-A70029
DEFINE g_ase_user STRING, #FUN-AA0052
       g_ase_psw  STRING, #FUN-AA0052
       g_ase_db   STRING  #FUN-AA0052
DEFINE g_log_list base.StringBuffer #為了紀錄本次執行有產生哪些log檔
DEFINE g_rebuild    STRING #FUN-A70115
DEFINE g_real_db    STRING #FUN-A70115
DEFINE g_real_msvdb STRING #FUN-A70115
DEFINE g_ods_exist  LIKE type_file.chr1   #FUN-B70083
#---FUN-B90135---start-----
DEFINE g_build_schema      STRING    #紀錄已打勾的schema
DEFINE g_plant_list        DYNAMIC ARRAY OF RECORD
          azw02_old           LIKE azw_file.azw02,
          azw01_old           LIKE azw_file.azw01,
          azw05_old           LIKE azw_file.azw05,
          azw02_new           LIKE azw_file.azw02,
          azw01_new           LIKE azw_file.azw01,
          azw05_new           LIKE azw_file.azw05        
                           END RECORD
#---FUN-B90135---end-------

FUNCTION p_create_schema()
   DEFINE l_cnt     LIKE type_file.num5   #FUN-B70083
   #FUN-9B0012:新建程式
   #OPTIONS                                  
   #   INPUT NO WRAP,
   #   FIELD ORDER FORM   
   #DEFER INTERRUPT #擷取中斷鍵, 由程式處理
 
   ##WHENEVER ERROR CALL cl_err_msg_log
   #IF NOT cl_user() THEN
   #   EXIT PROGRAM
   #END IF
 
   #IF (NOT cl_setup("AZZ")) THEN
   #   EXIT PROGRAM
   #END IF

   IF NOT p_create_schema_prep() THEN
      #Begin:FUN-A10121
      #RETURN FALSE
      CALL p_create_schema_info("azz1010", NULL) 
      RETURN
      #End:FUN-A10121 
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
 
   OPEN WINDOW p_create_schema_w WITH FORM "azz/42f/p_create_schema"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   #CALL cl_ui_init()
   CALL cl_ui_locale("p_create_schema") #call FUNCTION方式要改成呼叫cl_ui_locale

   LET g_db_type = cl_db_get_database_type() #FUN-A70028

   LET g_ods_exist = "Y"   #FUN-B70083
   CALL cl_set_comp_visible("Page5", FALSE)   #FUN-B90135 先關閉新/舊plant對應 輸入設定的頁籤
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL cl_set_comp_visible("Page4", FALSE)     #FUN-AA0052
         CALL cl_set_comp_visible("ed_ora_device", FALSE)          #FUN-B30150

         #---FUN-B70083---start-----
         #判斷當沒有ods schema時,就不需要重新rebuild ods
         SELECT COUNT(*) INTO l_cnt FROM all_users WHERE LOWER(username) ='ods'
         IF l_cnt = 0 THEN
            CALL cl_set_comp_visible("ods_rebuild", FALSE)
            LET g_ods_exist = "N"
            LET g_psw.ods_rebuild = "N"
         ELSE
            LET g_psw.ods_rebuild = "Y"
         END IF
         #---FUN-B70083---end-------
      WHEN "MSV"
         CALL cl_set_comp_visible("Page1", FALSE)
         CALL cl_set_comp_visible("Page4", FALSE)     #FUN-AA0052
      #---FUN-AA0052---start-----
      WHEN "ASE"
         CALL cl_set_comp_visible("Page1", FALSE)
         CALL cl_set_comp_visible("Page3", FALSE)
      #---FUN-AA0052---end-------
   END CASE

   CALL p_create_schema_menu()
 
   CLOSE WINDOW p_create_schema_w       

   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time    

   CALL cl_ins_del_sid(1, g_plant) #因為這程式並非單獨可執行的程式,而且過程中有切換過DB,因此最後要將sid_file的資料增加可以避免一些問題.

   #RETURN TRUE #FUN-A10121
END FUNCTION
 
#準備同一個Instance內的所有Schmea相關資訊.
FUNCTION p_create_schema_prep()
   DEFINE l_azw_sql STRING,
          l_i SMALLINT

   LET g_log_list = base.StringBuffer.create()

   CALL p_create_schema_init_global_var()

   LET l_azw_sql = "SELECT distinct 'N',azw02,azw09,azw05,azw03,'N',null,'N',null FROM azw_file WHERE azwacti='Y' AND azw05 = azw06", #FUN-9C0157:增加azw03   #FUN-B90135:增加azw05=azw06條件式,以準確地判斷出實體DB需要建立的部份
                   " UNION ",
                   "SELECT distinct 'N',azw02,azw09,azw06,NULL,'Y',azw05,'N',null FROM azw_file WHERE azwacti='Y' AND azw05<>azw06",
                   " ORDER BY 2,3,6,5,4" #要先建立實體Schema,才可以建立虛擬Schema. #FUN-A70028   #FUN-AA0052多加一個排序6是否為虛擬DB的排序,才會依先建立實體Schema,才可以建立虛擬Schema.
   DECLARE azw_cs CURSOR FROM l_azw_sql
   
   LET l_i = 1
   FOREACH azw_cs INTO g_list[l_i].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF

      IF cl_chk_schema_has_built(g_list[l_i].schema) THEN
         CONTINUE FOREACH
      END IF
      
      LET g_list[l_i].legal_db = DOWNSHIFT(g_list[l_i].legal_db)
      LET g_list[l_i].schema = DOWNSHIFT(g_list[l_i].schema)
      LET g_list[l_i].target_schema = DOWNSHIFT(g_list[l_i].target_schema)

      LET l_i = l_i + 1
   END FOREACH
   CALL g_list.deleteElement(l_i)
   
   #沒有任何未建立的Schema的話,就直接跳出程式:這是為了aooi931離開前呼叫本程式時的判斷.
   IF g_list.getLength()=0 THEN
      RETURN FALSE
   END IF

   #設定所有Schema的建立預設值.
   FOR l_i=1 TO g_list.getLength()
      #將schema轉成小寫,並設定為預設密碼.
      LET tm_arr[l_i].azp03_1 = g_list[l_i].schema
      LET tm_arr[l_i].ed_msv_sch = g_list[l_i].schema #FUN-A70028
      LET tm_arr[l_i].ed_ase_sch = g_list[l_i].schema #FUN-AA0052
      LET tm_arr[l_i].ed_ora_device = 'dbs1'          #FUN-AB0017
      LET tm_arr[l_i].ed_ase_device = 'dbs1'          #FUN-AB0017
      LET tm_arr[l_i].ed4 = p_create_schema_psw_encrypt(tm_arr[l_i].azp03_1) 
      LET tm_arr[l_i].ed4_1 = tm_arr[l_i].ed4
      IF g_list[l_i].is_virtual='Y' THEN
         #虛擬Schema不需要任何參考
         LET tm_arr[l_i].azp03_2 = null 
         LET tm_arr[l_i].ed_msv_ref_sch = null #FUN-A70028
         LET tm_arr[l_i].ed_ase_ref_sch = null #FUN-AA0052
      ELSE
         #要建立的Schema預設都是參考ds.
         LET tm_arr[l_i].azp03_2 = 'ds' 
         LET tm_arr[l_i].ed_msv_ref_sch = 'ds' #FUN-A70028
         LET tm_arr[l_i].ed_ase_ref_sch = 'ds' #FUN-AA0052
      END IF
      LET tm_arr[l_i].ed4_9 = null
      LET tm_arr[l_i].demo = 'N'
      LET tm_arr[l_i].base_data = 'N'    #FUN-B70083
      LET tm_arr[l_i].chk_msv_demo = 'N' #FUN-A70028
      LET tm_arr[l_i].chk_ase_demo = 'N' #FUN-AA0052
      #LET tm_arr[l_i].ind = 'std' #FUN-9C0157
   END FOR

   RETURN TRUE
END FUNCTION

#初始化公用變數:FUN-A30088
PRIVATE FUNCTION p_create_schema_init_global_var()
   CALL g_list.clear()
   CALL tm_arr.clear()
   INITIALIZE tm.* TO NULL
   LET g_azp03_1 = NULL
   INITIALIZE tmpsw.* TO NULL
   INITIALIZE g_psw.* TO NULL
   LET g_msv_user = NULL
   LET g_msv_psw = NULL
   LET g_ase_user = NULL   #FUN-AA0052
   LET g_ase_psw = NULL    #FUN-AA0052
   LET g_tmpdir = NULL
   LET g_idx = 0
   CALL g_syn_arr.clear()
   CALL g_view_arr.clear()  
   LET g_today_str = NULL
   CALL g_log_arr.clear()
   CALL g_ods_arr.clear()
   CALL g_sch_arr.clear()
   CALL g_log_list.clear()
END FUNCTION

#將密碼長度補到30碼
PRIVATE FUNCTION p_create_schema_psw_encrypt(p_psw)
   DEFINE p_psw STRING
   DEFINE l_i SMALLINT

   LET p_psw = p_psw.trim() #先去除兩邊空白會比較保險.
   IF p_psw.getIndexOf("-", 1)>0 THEN
      RETURN p_psw
   END IF

   #密碼最長30字元,未滿30字元補上減號(-).
   FOR l_i=p_psw.getLength()+1 TO 30
      LET p_psw = p_psw,"-"
   END FOR

   RETURN p_psw
END FUNCTION

#解開密碼
PRIVATE FUNCTION p_create_schema_psw_decrypt(p_psw)
   DEFINE p_psw STRING
   DEFINE l_i SMALLINT

   LET p_psw = p_psw.trim() #先去除兩邊空白會比較保險.
   IF p_psw.getIndexOf("-", 1)=0 THEN
      RETURN p_psw
   END IF

   FOR l_i=30 TO 1 STEP -1
      IF p_psw.getCharAt(l_i)<>"-" THEN
         LET p_psw = p_psw.subString(1, l_i)
         EXIT FOR
      END IF
   END FOR

   RETURN p_psw
END FUNCTION

PRIVATE FUNCTION p_create_schema_menu()
   DEFINE l_msg_param STRING

   LET g_tmpdir = os.Path.join(FGL_GETENV("TOP"), "tmp")
   IF NOT os.Path.exists(g_tmpdir) THEN #預設一定會有這個資料夾
      IF NOT os.Path.mkdir(g_tmpdir) THEN
         DISPLAY "Create folder ",g_tmpdir," fails."
         RETURN
      END IF
   END IF

   #LET g_pid = FGL_GETPID()
   #LET g_pid = g_pid.trim()
   LET g_today_str = TODAY USING "yymmdd" #FUN-9C0157

   WHILE TRUE
      CALL p_create_schema_bp()

      CASE g_action_choice
         WHEN "modify_psw" 
            IF cl_chk_act_auth() THEN 
               CASE g_db_type #FUN-A70028
                  WHEN "ORA"
                     #在進入編輯前判斷最適當,因為要建立Schema前一定得先輸入密碼.
                     IF p_create_schema_fglprofile() THEN
                        CALL p_create_schema_modify()
                     END IF
                  WHEN "MSV" #MSV就不需要檢查了.
                     CALL p_create_schema_modify()
                  #---FUN-AA0052---start-----
                  WHEN "ASE"
                     IF p_create_schema_fglprofile() THEN
                        CALL p_create_schema_modify()
                     END IF
                  #---FUN-AA0052---end-------
               END CASE
            END IF

         WHEN "build_all" 
            IF cl_chk_act_auth() THEN 
               #---FUN-B90135---start-----
               IF p_create_schema_tbPlant_b() THEN
                  DISPLAY "Input plant success."
               #---FUN-B90135---end-----
                  IF p_create_schema_conf("azz1013") THEN
                     CALL p_create_schema_build_all()
                  END IF
               #---FUN-B90135---start-----
               ELSE
                  #輸入營運中心對應關係失敗,取消建立作業
                  CALL p_create_schema_info("azz1197", NULL) 
               END IF      
               #---FUN-B90135---end-------        
            END IF
            
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

PRIVATE FUNCTION p_create_schema_bp()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   INPUT ARRAY g_list WITHOUT DEFAULTS FROM s_tb1.*
                      ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         LET g_action_choice = null 

         IF g_idx>0 THEN
            CALL FGL_SET_ARR_CURR(g_idx)
         END IF

      BEFORE ROW
         LET g_idx = ARR_CURR()
         IF g_idx>0 THEN
            CALL p_create_schema_show_detail()
            CALL p_create_schema_refresh_log()
         END IF
   
      ON ACTION modify_psw
         IF g_idx>0 THEN
            LET g_action_choice = "modify_psw"
            EXIT INPUT
         END IF
   
      ON ACTION select_all
         CALL p_create_schema_sel('Y')

      ON ACTION cancel_all
         CALL p_create_schema_sel('N')

      ON CHANGE sel 
         CALL p_create_schema_sel_change()

      ON ACTION build_all
         IF g_list.getLength()>0 THEN
            IF p_create_schema_check_null() THEN
               LET g_action_choice = "build_all"
            ELSE
               LET g_action_choice = "modify_psw" #自動進入編輯狀態
            END IF
            EXIT INPUT
         END IF
      
      ON ACTION locale
         CALL cl_dynamic_locale()
      
      ON ACTION controlg
         CALL cl_cmdask()
      
      ON ACTION about       
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT INPUT

      #---FUN-AA0052---start-----
      ON ACTION close  
         LET g_action_choice = "exit"
         EXIT INPUT
      #---FUN-AA0052---end-------
   END INPUT
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#顯現詳細資料.
PRIVATE FUNCTION p_create_schema_show_detail()
   LET tm.* = tm_arr[g_idx].*
   LET tmpsw.* = g_psw.* #FUN-9C0157:順便改這個Bug

   DISPLAY BY NAME tmpsw.ed4_2,tmpsw.ed4_4,tmpsw.ed4_6,
                   tm.azp03_1,tm.ed4,tm.ed4_1, 
                   tm.azp03_2,tm.ed_ora_device,tm.ed4_9,tm.demo, #,tm.ind #FUN-9C0157     #FUN-AB0017 add ed_ora_device
                   tm.base_data, tmpsw.ods_rebuild,                 #FUN-B70083 add base_data, ods_rebuild二欄位
                   tm.ed_msv_sch,tm.ed_msv_ref_sch,tm.chk_msv_demo, #FUN-A70028
                   tm.ed_ase_sch,tm.ed_ase_ref_sch,tm.chk_ase_demo, #FUN-AA0052
                   tm.ed_ase_device #FUN-AB0017
                   
END FUNCTION

#將有紀錄的log檔寫入暫存變數(g_log_list)
PRIVATE FUNCTION p_create_schema_log_list(p_log)
   DEFINE p_log STRING

   IF g_log_list.getLength()=0 THEN
      CALL g_log_list.append(p_log)
   ELSE
      IF g_log_list.getIndexOf(p_log, 1)=0 THEN
         LET p_log = ",",p_log
         CALL g_log_list.append(p_log)
      END IF
   END IF
END FUNCTION

#重新載入記錄檔
PRIVATE FUNCTION p_create_schema_refresh_log()
   IF g_log_arr.getLength()>0 THEN
      DISPLAY g_log_arr[g_idx].te1 TO te1
      DISPLAY g_log_arr[g_idx].te2 TO te2
      DISPLAY g_log_arr[g_idx].te3 TO te3
      DISPLAY g_log_arr[g_idx].te4 TO te4
      DISPLAY g_log_arr[g_idx].te5 TO te5
      DISPLAY g_log_arr[g_idx].te6 TO te6
      DISPLAY g_log_arr[g_idx].te7 TO te7
      DISPLAY g_log_arr[g_idx].te8 TO te8
      DISPLAY g_log_arr[g_idx].te9 TO te9

      CALL cl_set_comp_visible("Page5", TRUE)     #FUN-B90135
   ELSE
      DISPLAY NULL TO te1
      DISPLAY NULL TO te2
      DISPLAY NULL TO te3
      DISPLAY NULL TO te4
      DISPLAY NULL TO te5
      DISPLAY NULL TO te6
      DISPLAY NULL TO te7
      DISPLAY NULL TO te8
      DISPLAY NULL TO te9

      #CALL cl_set_comp_visible("Page5", FALSE)     #FUN-B90135
   END IF
   #te10:不需要重新載入,因為每次的build_all都只有一份.
END FUNCTION

#勾選/取消sel時的判斷.
PRIVATE FUNCTION p_create_schema_sel_change()
   #已建立過的schema就不能勾選.
   IF g_list[g_idx].has_built='Y' THEN
      LET g_list[g_idx].sel = 'N'

      DISPLAY ARRAY g_list TO s_tb1.*
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
   END IF
END FUNCTION

#檢查必要欄位是否為null
PRIVATE FUNCTION p_create_schema_check_null()
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         IF cl_null(tmpsw.ed4_2) OR
            cl_null(tmpsw.ed4_4) OR
            cl_null(tmpsw.ed4_6) OR
            cl_null(tm.azp03_1) OR
            cl_null(tm.ed4) OR
            cl_null(tm.ed4_1) THEN
            CALL cl_err_msg(null,"alm-978",null,10)
            RETURN FALSE
         END IF      
      WHEN "MSV"
         IF cl_null(tmpsw.ed_msv_user) OR
            cl_null(tmpsw.ed_msv_psw) OR
            cl_null(tm.ed_msv_sch) THEN
            CALL cl_err_msg(null,"alm-978",null,10)
            RETURN FALSE
         END IF    
      #---FUN-AA0052---start-----
      WHEN "ASE"
         IF cl_null(tmpsw.ed_ase_user) OR
            cl_null(tmpsw.ed_ase_psw) OR
            cl_null(tm.ed_ase_sch) THEN
            CALL cl_err_msg(null,"alm-978",null,10)
            RETURN FALSE
         END IF
     #---FUN-AA0052---end-------    
   END CASE

   RETURN TRUE
END FUNCTION

#設定全選/全不選.
PRIVATE FUNCTION p_create_schema_sel(p_sel)
   DEFINE p_sel STRING
   DEFINE l_t SMALLINT

   FOR l_t=1 TO g_list.getLength()
      #已建立過的schema就不能勾選.
      IF g_list[l_t].has_built='N' THEN
         LET g_list[l_t].sel = p_sel
      END IF
   END FOR

   DISPLAY ARRAY g_list TO s_tb1.*
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
END FUNCTION

#判斷登入使用者是否有寫入FGLPROFILE的權限.
#因為createsch需要寫入FGLPROFILE,所以程式執行前就先判斷.
PRIVATE FUNCTION p_create_schema_fglprofile()
   DEFINE l_fglprofile STRING
   #---FUN-B10033---start--mark
   #       l_rwx SMALLINT
   #DEFINE l_user STRING,
   #       l_uid_int,l_gid_int INTEGER,
   #       l_fglprofile_uid,l_fglprofile_gid STRING
   #DEFINE l_cmd STRING,
   #       l_channel base.Channel,
   #       l_str STRING,
   #       l_uid_idx,l_gid_idx,l_equal_idx,l_left_bracket_idx SMALLINT,
   #       l_uid,l_gid STRING
   #---FUN-B10033---end-------
   DEFINE l_flag BOOLEAN
  
   #---FUN-B10033---start-------------------- 
   #LET l_fglprofile = FGL_GETENV("FGLPROFILE")
   ##FGLPROFILE的權限預設為775(rwxrwxr-x):rwx=509,也有可能是755(rwxr-xr-x):rwx=493
   #LET l_rwx = os.Path.rwx(l_fglprofile)   
   #IF l_rwx<>509 AND l_rwx<>493 THEN
   #   CALL cl_err_msg(null,"azz1030",NULL,10)
   #   RETURN FALSE      
   #END IF
   #
   ##先取得FGLPROFILE的uid.
   #LET l_uid_int = os.Path.uid(l_fglprofile)
   #LET l_fglprofile_uid = l_uid_int
   #LET l_fglprofile_uid = l_fglprofile_uid.trim()
   ##再取得目前登入使用者的uid資訊.
   ##範例:
   ##id|grep top
   ##uid=401(top) gid=401(top) groups=300(informix),400(tiptop),401(top),410(topeng),501(dba)
   #LET l_user = g_user CLIPPED
   #LET l_cmd = "id|grep ",l_user
   #LET l_channel = base.Channel.create()
   #CALL l_channel.openPipe(l_cmd, "r")
   #WHILE l_channel.read(l_str)
   #END WHILE
   #CALL l_channel.close()
   #
   ##依據登入使用者的id資訊擷取uid.
   #LET l_uid_idx = l_str.getIndexOf("uid", 1)
   #IF l_uid_idx>0 THEN
   #   LET l_equal_idx = l_str.getIndexOf("=", l_uid_idx+3)
   #   IF l_equal_idx>0 THEN
   #      LET l_left_bracket_idx = l_str.getIndexOf("(", l_equal_idx+1)
   #      IF l_left_bracket_idx>0 THEN
   #         LET l_uid = l_str.subString(l_equal_idx+1, l_left_bracket_idx-1)
   #         LET l_uid = l_uid.trim()
   #      END IF
   #   END IF
   #END IF
   #
   ##絕不會找不到uid.
   #IF NOT cl_null(l_uid) THEN
   #   IF l_uid=l_fglprofile_uid THEN
   #      LET l_flag = TRUE
   #   END IF
   #END IF
   #
   ##登入使用者和FGLPROFILE的owner不同時,要繼續判斷是否為相同群組.
   #IF NOT l_flag THEN
   #   IF l_rwx=509 THEN #FGLPROFILE權限為509(rwxrwxr-x)時,才需要在owner不同時繼續比對group.
   #      #先取得FGLPROFILE的gid.
   #      LET l_gid_int = os.Path.gid(l_fglprofile)
   #      LET l_fglprofile_gid = l_gid_int
   #      LET l_fglprofile_gid = l_fglprofile_gid.trim()
   #      
   #      #gid的位置:uid=401(top) gid=401(top)
   #      LET l_gid_idx = l_str.getIndexOf("gid", l_left_bracket_idx+l_user.getLength()+1+1) #從右括號')'的下一個位元開始找.
   #      IF l_gid_idx>0 THEN
   #         LET l_equal_idx = l_str.getIndexOf("=", l_gid_idx+3)
   #         IF l_equal_idx>0 THEN
   #            LET l_left_bracket_idx = l_str.getIndexOf("(", l_equal_idx+1)
   #            IF l_left_bracket_idx>0 THEN
   #               LET l_gid = l_str.subString(l_equal_idx+1, l_left_bracket_idx-1)
   #               LET l_gid = l_gid.trim()
   #            END IF
   #         END IF
   #      END IF
   #      
   #      #絕不會找不到gid.
   #      IF NOT cl_null(l_gid) THEN
   #         IF l_gid=l_fglprofile_gid THEN
   #            LET l_flag = TRUE
   #         END IF
   #      END IF
   #   END IF
   #END IF
   # 
   #IF NOT l_flag THEN
   #   CALL cl_err_msg(null,"azz1029",g_user,10)
   #END IF
   LET l_fglprofile = FGL_GETENV("FGLPROFILE")
   LET l_flag = os.Path.writable(l_fglprofile)
   IF NOT l_flag THEN
      CALL cl_err_msg(null,"azz1029",g_user,10)
   END IF 
   #---FUN-B10033---end----------------------
   RETURN l_flag
END FUNCTION

#修改Schema建立時的密碼資訊.
PRIVATE FUNCTION p_create_schema_modify()
   DEFINE l_i SMALLINT
   DEFINE l_conn STRING
   DEFINE l_n LIKE type_file.num5           
   DEFINE l_legal_db LIKE type_file.chr1   #FUN-B90135
 
   CALL cl_set_act_visible("accept,cancel", TRUE)

   LET tm.* = tm_arr[g_idx].*
   LET tmpsw.* = g_psw.* #FUN-9C0157:順便改這個Bug

   INPUT BY NAME tmpsw.ed4_2,tmpsw.ed4_4,tmpsw.ed4_6,
                 tm.azp03_1,tm.ed4,tm.ed4_1,
                 tm.azp03_2,tm.ed4_9,tm.ed_ora_device,tm.demo, #,tm.ind #FUN-9C0157   #FUN-AB0017 add ed_ora_device
                 tm.base_data, tmpsw.ods_rebuild,    #FUN-B70083 add base_data, ods_rebuild二欄位
                 tmpsw.ed_msv_user,tmpsw.ed_msv_psw, #FUN-A70028
                 tm.ed_msv_sch,tm.ed_msv_ref_sch,tm.chk_msv_demo,
                 tmpsw.ed_ase_user,tmpsw.ed_ase_psw,                #FUN-AA0052
                 tm.ed_ase_sch,tm.ed_ase_ref_sch,tm.chk_ase_demo,   #FUN-AA0052
                 tm.ed_ase_device    #FUN-AB0017
                 WITHOUT DEFAULTS
      BEFORE INPUT
         CASE g_db_type
            WHEN "ORA"
               #只要'ds'密碼有輸入,代表需要輸入密碼的欄位都已輸入正確,所以就不需要再進入編輯ds,system,sys這三個欄位了.
               IF NOT cl_null(tmpsw.ed4_2) THEN 
                  CALL cl_set_comp_entry("ed4_2,ed4_4,ed4_6", FALSE)
               END IF

               IF g_list[g_idx].is_virtual='Y' THEN
                  #虛擬資料庫不需要任何參考,只需單純建立一個user即可.
                  #CALL cl_set_comp_entry("azp03_2,ed4_9,demo,ind", FALSE)
                  CALL cl_set_comp_entry("azp03_2,ed4_9,demo,base_data", FALSE) #FUN-9C0157 #FUN-B70083 add base_data欄位
                  CALL cl_set_comp_entry("ed_ora_device", TRUE)       #FUN-AB0017
               ELSE
                  IF tm.azp03_2='ds' THEN
                     CALL cl_set_comp_entry("ed4_9", FALSE)
                     CALL cl_set_comp_entry("azp03_2,demo,base_data", TRUE)     #FUN-B70083 add base_data欄位
                     CALL cl_set_comp_entry("ed_ora_device", TRUE)       #FUN-AB0017
                  ELSE
                     CALL cl_set_comp_entry("azp03_2,ed4_9", TRUE)
                     CALL cl_set_comp_entry("demo", FALSE)
                     CALL cl_set_comp_entry("ed_ora_device,base_data", TRUE)    #FUN-AB0017 #FUN-B70083 add base_data欄位
                  END IF
               
                  #CALL p_create_schema_demo_change(tm.demo) #FUN-9C0157
               END IF
            WHEN "MSV" #FUN-A70028
               IF NOT cl_null(tmpsw.ed_msv_user) THEN 
                  CALL cl_set_comp_entry("ed_msv_user,ed_msv_psw", FALSE)
               END IF

               IF g_list[g_idx].is_virtual='Y' THEN
                  #虛擬資料庫不需要任何參考,只需單純建立一個user即可.
                  CALL cl_set_comp_entry("ed_msv_ref_sch,chk_msv_demo", FALSE) #FUN-9C0157
               ELSE
                  IF tm.ed_msv_ref_sch='ds' THEN
                     CALL cl_set_comp_entry("ed_msv_ref_sch,chk_msv_demo", TRUE)
                  ELSE
                     CALL cl_set_comp_entry("ed_msv_ref_sch", TRUE)
                     CALL cl_set_comp_entry("chk_msv_demo", FALSE)
                  END IF
               END IF
            #---FUN-AA0052---start-----
            WHEN "ASE" #FUN-AA0052
               IF NOT cl_null(tmpsw.ed_ase_user) THEN 
                  CALL cl_set_comp_entry("ed_ase_user,ed_ase_psw", FALSE)
               END IF

               IF g_list[g_idx].is_virtual='Y' THEN
                  #虛擬資料庫不需要任何參考,只需單純建立一個user即可.
                  CALL cl_set_comp_entry("ed_ase_ref_sch,chk_ase_demo", FALSE)
                  CALL cl_set_comp_entry("ed_ase_device", TRUE)   #FUN-AB0017
               ELSE
                  IF tm.ed_ase_ref_sch='ds' THEN
                     CALL cl_set_comp_entry("ed_ase_ref_sch,chk_ase_demo,ed_ase_device", TRUE)   #FUN-AB0017
                  ELSE
                     CALL cl_set_comp_entry("ed_ase_ref_sch,ed_ase_device", TRUE)   #FUN-AB0017
                     CALL cl_set_comp_entry("chk_ase_demo", FALSE)
                  END IF
               END IF
            #---FUN-AA0052---end-------
         END CASE
 
      AFTER FIELD ed4_2 #ds
         #IF cl_null(tmpsw.ed4_2) THEN
         #   CALL cl_err('','mfg0037',0)
         #   NEXT FIELD ed4_2
         #ELSE
         IF NOT cl_null(tmpsw.ed4_2) THEN #FUN-A70028:因為MSV時,會將ORA設定資訊的頁籤隱藏,這樣會導致INPUT一開始,就進來檢查,結果造成無窮迴圈.
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tmpsw.ed4_2 = p_create_schema_psw_decrypt(tmpsw.ed4_2)
            #檢查密碼是否正確
            IF p_db_psw_check("ds", tmpsw.ed4_2 CLIPPED) THEN
               LET tmpsw.ed4_2 = p_create_schema_psw_encrypt(tmpsw.ed4_2)
               DISPLAY BY NAME tmpsw.ed4_2
               IF g_list[g_idx].is_virtual<>'Y' THEN
                  LET tm.ed4_9 = tmpsw.ed4_2
                  DISPLAY BY NAME tm.ed4_9
               END IF
            ELSE
               LET tmpsw.ed4_2 = null
               DISPLAY BY NAME tmpsw.ed4_2
               NEXT FIELD ed4_2
            END IF 
         END IF 

      AFTER FIELD ed4_4 #system
         #IF cl_null(tmpsw.ed4_4) THEN
         #   CALL cl_err('','mfg0037',0)
         #   NEXT FIELD ed4_4
         #ELSE
         IF NOT cl_null(tmpsw.ed4_4) THEN #FUN-A70028
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tmpsw.ed4_4 = p_create_schema_psw_decrypt(tmpsw.ed4_4)
            IF p_db_psw_check("system", tmpsw.ed4_4 CLIPPED) THEN
               LET tmpsw.ed4_4 = p_create_schema_psw_encrypt(tmpsw.ed4_4)
               DISPLAY BY NAME tmpsw.ed4_4
            ELSE
               LET tmpsw.ed4_4 = null
               DISPLAY BY NAME tmpsw.ed4_4
               NEXT FIELD ed4_4
            END IF
         END IF
    
      AFTER FIELD ed4_6 #sys
         #IF cl_null(tmpsw.ed4_6) THEN
         #   CALL cl_err('','mfg0037',0)
         #   NEXT FIELD ed4_6
         #ELSE
         IF NOT cl_null(tmpsw.ed4_6) THEN #FUN-A70028
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tmpsw.ed4_6 = p_create_schema_psw_decrypt(tmpsw.ed4_6)
            #SYSDBA一定要大寫.
            IF p_db_psw_check("sys/SYSDBA", tmpsw.ed4_6 CLIPPED) THEN
               LET tmpsw.ed4_6 = p_create_schema_psw_encrypt(tmpsw.ed4_6)
               DISPLAY BY NAME tmpsw.ed4_6
            ELSE
               LET tmpsw.ed4_6 = null
               DISPLAY BY NAME tmpsw.ed4_6
               NEXT FIELD ed4_6
            END IF
         END IF
    
      AFTER FIELD ed4
         #IF cl_null(tm.ed4) THEN
         #   CALL cl_err('','mfg0037',0)
         #   NEXT FIELD ed4
         #ELSE
         IF NOT cl_null(tm.ed4) THEN #FUN-A70028
            LET tm.ed4 = p_create_schema_psw_encrypt(tm.ed4)
            DISPLAY BY NAME tm.ed4
            NEXT FIELD ed4_1 #強制跳到複檢欄位.
         END IF
    
      AFTER FIELD ed4_1
         #IF cl_null(tm.ed4) THEN
         #   LET tm.ed4_1 = null
         #   DISPLAY BY NAME tm.ed4_1
         #   NEXT FIELD ed4
         #END IF

         #IF cl_null(tm.ed4_1) THEN
         #   NEXT FIELD ed4_1
         #ELSE
         IF NOT cl_null(tm.ed4_1) THEN #FUN-A70028
            LET tm.ed4_1 = p_create_schema_psw_encrypt(tm.ed4_1)
            DISPLAY BY NAME tm.ed4_1
         END IF

         IF NOT cl_null(tm.ed4) AND NOT cl_null(tm.ed4_1) THEN #FUN-A70028
            IF tm.ed4<>tm.ed4_1 THEN
               #複檢不過時,要將兩個欄位的資料清空.
               CALL cl_err('','azz-882',0)
               LET tm.ed4 = null
               DISPLAY BY NAME tm.ed4
               LET tm.ed4_1 = null
               DISPLAY BY NAME tm.ed4_1
               NEXT FIELD ed4
            END IF
         END IF

      AFTER FIELD azp03_2
         #IF cl_null(tm.azp03_2) THEN 
         #   CALL cl_err('','mfg0037',0) 
         #   NEXT FIELD azp03_2
         #ELSE 
         IF NOT cl_null(tm.azp03_2) THEN #FUN-A70028
            #檢查是否存在.
            SELECT COUNT(*) INTO l_n
              FROM azp_file 
             WHERE azp03= tm.azp03_2
            IF l_n=0 THEN 
               CALL cl_err('','agl-118',0) 
               NEXT FIELD azp03_2
            ELSE
               #檢查是否已經建立.
               IF NOT cl_chk_schema_has_built(tm.azp03_2) THEN
                  CALL cl_err_msg('','azz1025',tm.azp03_2, 10) 
                  NEXT FIELD azp03_2
               ELSE #已經建立.
                  #檢查參考資料庫是否不為虛擬Schema.
                  SELECT count(*) INTO l_n FROM azw_file WHERE azw05=tm.azp03_2
                  IF l_n=0 THEN
                     CALL cl_err_msg('','azz1026',tm.azp03_2, 10) 
                     NEXT FIELD azp03_2
                  ELSE #實體Schema
                     IF DOWNSHIFT(tm.azp03_2)='ds' THEN
                        #若是參考的資料庫是'ds',則不需要輸入ed4_9這個欄位,避免密碼的設定又和共用的'ds'密碼不相同.
                        #本來預設就是這樣,但是有可能改來改去,所以才這樣處理.
                        LET tm.ed4_9 = tmpsw.ed4_2
                        DISPLAY BY NAME tm.ed4_9
                        CALL cl_set_comp_entry("ed4_9", FALSE)
                        CALL cl_set_comp_entry("demo,base_data", TRUE)    #FUN-B70083 add base_data欄位
                     ELSE
                        #---FUN-B90135---start-----
                        #判斷一下所要參考的資料庫,是否符合財務DB的建立規則.
                        #例:ds4自己本身也為法人db,但卻參考了ds2(不為法人db)建立,
                        #這樣有很多table和synonym的型態會建立錯誤
                        IF g_list[g_idx].is_virtual = "N" THEN
                           #檢查一下參考的資料庫本身是不是法人db
                           SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw09 = tm.azp03_2
                           IF l_n > 0 THEN
                              LET l_legal_db = "Y"
                           ELSE
                              LET l_legal_db = "N"
                           END IF

                           #檢查如果是一個法人(財務)DB的建立,卻參考了非法人db的建立來源錯誤
                           IF g_list[g_idx].legal_db = g_list[g_idx].schema AND l_legal_db = "N" THEN
                              CALL cl_err_msg("", "azz1198", tm.azp03_2 || "|" || tm.azp03_1, 10)
                              NEXT FIELD azp03_2
                           END IF
                        END IF
                        #---FUN-B90135---end-------
                        #參考schema不是'ds'時,則必須勾選'產生的資料庫須有Demo Data',並且不能取消.
                        LET tm.demo = 'Y'
                        DISPLAY BY NAME tm.demo
                        CALL cl_set_comp_entry("demo", FALSE)
                        CALL cl_set_comp_entry("ed4_9,base_data", TRUE)    #FUN-B70083 add base_data欄位
                        #CALL p_create_schema_demo_change(tm.demo) #FUN-9C0157
                     
                        #不想搞這麼複雜,參考DB的密碼就直接預設,但不檢查.
                        LET tm.ed4_9 = p_create_schema_psw_encrypt(tm.azp03_2)
                        DISPLAY BY NAME tm.ed4_9
                        #強制跳到密碼輸入欄位.
                        NEXT FIELD ed4_9
                     END IF #IF tm.azp03_2='ds'
                  END IF #IF l_n=0:檢查所參考的Schema是否不是虛擬Schema.
               END IF #IF l_n=0:檢查所參考的Schema是否已經建立
            END IF #IF l_n=0:檢查azp03 
         END IF #IF cl_null 

      AFTER FIELD ed4_9
         #IF cl_null(tm.ed4_9) THEN
         #   CALL cl_err('','mfg0037',0)
         #   NEXT FIELD ed4_9
         #ELSE
         IF NOT cl_null(tm.ed4_9) THEN #FUN-A70028
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tm.ed4_9 = p_create_schema_psw_decrypt(tm.ed4_9)
            #檢查密碼是否正確
            IF p_db_psw_check(tm.azp03_2 CLIPPED, tm.ed4_9) THEN
               LET tm.ed4_9 = p_create_schema_psw_encrypt(tm.ed4_9)
               DISPLAY BY NAME tm.ed4_9
            ELSE
               LET tm.ed4_9 = null
               DISPLAY BY NAME tm.ed4_9
               NEXT FIELD ed4_9
            END IF
         END IF

      #FUN-9C0157
      #ON CHANGE demo
      #   CALL p_create_schema_demo_change(tm.demo)

      AFTER FIELD ed_msv_psw #FUN-A70028
         IF NOT cl_null(tmpsw.ed_msv_psw) THEN
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tmpsw.ed_msv_psw = p_create_schema_psw_decrypt(tmpsw.ed_msv_psw)
            #檢查密碼是否正確
            IF p_db_psw_check(tmpsw.ed_msv_user, tmpsw.ed_msv_psw CLIPPED) THEN
               LET tmpsw.ed_msv_psw = p_create_schema_psw_encrypt(tmpsw.ed_msv_psw)
               DISPLAY BY NAME tmpsw.ed_msv_psw
            ELSE
               LET tmpsw.ed_msv_psw = null
               DISPLAY BY NAME tmpsw.ed_msv_psw
               NEXT FIELD ed_msv_psw
            END IF 
         END IF 

      AFTER FIELD ed_msv_ref_sch #FUN-A70028
         IF NOT cl_null(tm.ed_msv_ref_sch) THEN 
            #檢查是否存在.
            SELECT COUNT(*) INTO l_n
              FROM azp_file 
             WHERE azp03= tm.ed_msv_ref_sch
            IF l_n=0 THEN 
               CALL cl_err('','agl-118',0) 
               NEXT FIELD ed_msv_ref_sch
            ELSE
               #檢查是否已經建立.
               IF NOT cl_chk_schema_has_built(tm.ed_msv_ref_sch) THEN
                  CALL cl_err_msg('','azz1025',tm.ed_msv_ref_sch, 10) 
                  NEXT FIELD ed_msv_ref_sch
               ELSE #已經建立.
                  #檢查參考資料庫是否不為虛擬Schema.
                  SELECT count(*) INTO l_n FROM azw_file WHERE azw05=tm.ed_msv_ref_sch
                  IF l_n=0 THEN
                     CALL cl_err_msg('','azz1026',tm.ed_msv_ref_sch, 10) 
                     NEXT FIELD ed_msv_ref_sch
                  ELSE #實體Schema
                     IF DOWNSHIFT(tm.ed_msv_ref_sch)='ds' THEN
                        CALL cl_set_comp_entry("chk_msv_demo", TRUE)
                     ELSE
                        #參考schema不是'ds'時,則必須勾選'產生的資料庫須有Demo Data',並且不能取消.
                        #LET tm.demo = 'Y'                          #FUN-AA0052 mark此處應該是用msv的變數
                        #DISPLAY tm.demo TO chk_msv_demo            #FUN-AA0052 mark
                        LET tm.chk_msv_demo = 'Y'                   #FUN-AA0052
                        DISPLAY tm.chk_msv_demo TO chk_msv_demo    #FUN-AA0052
                        CALL cl_set_comp_entry("chk_msv_demo", FALSE)
                     END IF #IF tm.ed_msv_ref_sch='ds'
                  END IF #IF l_n=0:檢查所參考的Schema是否不是虛擬Schema.
               END IF #IF l_n=0:檢查所參考的Schema是否已經建立
            END IF #IF l_n=0:檢查azp03 
         END IF #IF cl_null 

      #---FUN-AA0052---start-----
      AFTER FIELD ed_ase_psw
         IF NOT cl_null(tmpsw.ed_ase_psw) THEN
            #這樣可以避免再次進入時,是用加密過的密碼檢查連線.
            LET tmpsw.ed_ase_psw = p_create_schema_psw_decrypt(tmpsw.ed_ase_psw)
            #檢查密碼是否正確
            IF p_db_psw_check(tmpsw.ed_ase_user, tmpsw.ed_ase_psw CLIPPED) THEN
               LET tmpsw.ed_ase_psw = p_create_schema_psw_encrypt(tmpsw.ed_ase_psw)
               DISPLAY BY NAME tmpsw.ed_ase_psw
            ELSE
               LET tmpsw.ed_ase_psw = null
               DISPLAY BY NAME tmpsw.ed_ase_psw
               NEXT FIELD ed_ase_psw
            END IF 
         END IF 

      AFTER FIELD ed_ase_ref_sch 
         IF NOT cl_null(tm.ed_ase_ref_sch) THEN 
            #檢查是否存在.
            SELECT COUNT(*) INTO l_n
              FROM azp_file 
             WHERE azp03= tm.ed_ase_ref_sch
            IF l_n=0 THEN 
               CALL cl_err('','agl-118',0) 
               NEXT FIELD ed_ase_ref_sch
            ELSE
               #檢查是否已經建立.
               IF NOT cl_chk_schema_has_built(tm.ed_ase_ref_sch) THEN
                  CALL cl_err_msg('','azz1025',tm.ed_ase_ref_sch, 10) 
                  NEXT FIELD ed_ase_ref_sch
               ELSE #已經建立.
                  #檢查參考資料庫是否不為虛擬Schema.
                  SELECT count(*) INTO l_n FROM azw_file WHERE azw05=tm.ed_ase_ref_sch
                  IF l_n=0 THEN
                     CALL cl_err_msg('','azz1026',tm.ed_ase_ref_sch, 10) 
                     NEXT FIELD ed_ase_ref_sch
                  ELSE #實體Schema
                     IF DOWNSHIFT(tm.ed_ase_ref_sch)='ds' THEN
                        CALL cl_set_comp_entry("chk_ase_demo", TRUE)
                     ELSE
                        #參考schema不是'ds'時,則必須勾選'產生的資料庫須有Demo Data',並且不能取消.
                        LET tm.chk_ase_demo = 'Y'
                        DISPLAY tm.chk_ase_demo TO chk_ase_demo
                        CALL cl_set_comp_entry("chk_ase_demo", FALSE)
                     END IF #IF tm.ed_ase_ref_sch='ds'
                  END IF #IF l_n=0:檢查所參考的Schema是否不是虛擬Schema.
               END IF #IF l_n=0:檢查所參考的Schema是否已經建立
            END IF #IF l_n=0:檢查azp03 
         END IF #IF cl_null 
      #---FUN-AA0052---end-------

      #---FUN-AB0017---start-----
      AFTER FIELD ed_ora_device
         IF tm.ed_ora_device IS NULL THEN
            LET tm.ed_ora_device = 'dbs1'
            DISPLAY tm.ed_ora_device TO ed_ora_device
         END IF
         
      AFTER FIELD ed_ase_device
         IF tm.ed_ase_device IS NULL THEN
            LET tm.ed_ase_device = 'dbs1'
            DISPLAY tm.ed_ase_device TO ed_ase_device
         END IF
      #---FUN-AB0017---end-------

      ON ACTION controlp INFIELD azp03_2
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_azw10"
         LET g_qryparam.default1= tm.azp03_2
         CALL cl_create_qry() RETURNING tm.azp03_2
         DISPLAY tm.azp03_2 TO azp03_2
         NEXT FIELD azp03_2
    
      ON ACTION controlp INFIELD ed_msv_ref_sch #FUN-A70028
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_azw10"
         LET g_qryparam.default1= tm.ed_msv_ref_sch
         CALL cl_create_qry() RETURNING tm.ed_msv_ref_sch
         DISPLAY tm.ed_msv_ref_sch TO ed_msv_ref_sch
         NEXT FIELD ed_msv_ref_sch

      #---FUN-AA0052---start-----
      ON ACTION controlp INFIELD ed_ase_ref_sch 
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_azw10"
         LET g_qryparam.default1= tm.ed_ase_ref_sch
         CALL cl_create_qry() RETURNING tm.ed_ase_ref_sch
         DISPLAY tm.ed_ase_ref_sch TO ed_ase_ref_sch
         NEXT FIELD ed_ase_ref_sch
      #---FUN-AA0052---end-------

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      AFTER INPUT
         IF INT_FLAG THEN #非按下'確定'離開時,要將資料還原.
            CALL p_create_schema_show_detail()
            EXIT INPUT
         END IF
    
         CASE g_db_type #FUN-A70028
            WHEN "ORA"
               #離開編輯時檢查是否為NULL:規則同p_create_schema_check_null().
               CALL cl_set_comp_required("ed4_2,ed4_4,ed4_6,azp03_1,ed4,ed4_1",TRUE)
               
               FOR l_i=1 TO g_list.getLength()
                  #同步更新所有新建Schema的ds密碼
                  IF tm_arr[l_i].azp03_2='ds' THEN
                     LET tm_arr[l_i].ed4_9 = tmpsw.ed4_2
                  END IF
               END FOR
            WHEN "MSV"
               CALL cl_set_comp_required("ed_msv_user,ed_msv_psw,ed_msv_sch",TRUE)
            #---FUN-AA0052---start-----
            WHEN "ASE"
               CALL cl_set_comp_required("ed_ase_user,ed_ase_psw,ed_ase_sch",TRUE)
            #---FUN-AA0052---end-------
         END CASE

         LET tm_arr[g_idx].* = tm.*
         LET g_psw.* = tmpsw.* #FUN-9C0157:順便改這個Bug
   END INPUT

   CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION

#FUN-9C0157
##demo欄位選項改變時的連動.
#PRIVATE FUNCTION p_create_schema_demo_change(l_demo)
#   DEFINE l_demo LIKE type_file.chr1
#
#   IF l_demo = 'Y' THEN
#      CALL cl_set_comp_entry("ind",TRUE)
#   ELSE
#      LET tm.ind = 'std'
#      CALL cl_set_comp_entry("ind",FALSE)
#   END IF
#END FUNCTION

#確認是否要建立Schema
FUNCTION p_create_schema_conf(p_msg_code)
   DEFINE p_msg_code STRING
   DEFINE l_conf_flag BOOLEAN

   MENU "Confirm Dialog" ATTRIBUTES (STYLE="dialog", COMMENT=cl_getmsg(p_msg_code, g_lang))
      ON ACTION accept
         LET l_conf_flag = TRUE
         EXIT MENU
      ON ACTION cancel
         LET l_conf_flag = FALSE
         EXIT MENU      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU

   CALL ui.interface.refresh() #為了及時關閉對話視窗得要重新refresh.

   RETURN l_conf_flag
END FUNCTION

#建立所有Schema.
PRIVATE FUNCTION p_create_schema_build_all()
   DEFINE l_i,l_tmp_idx SMALLINT
   DEFINE l_ods_flag,l_virtual_flag BOOLEAN
   DEFINE l_cmd STRING
   DEFINE l_log_file,l_log_path STRING
   DEFINE l_cont_flag BOOLEAN
   DEFINE l_err_msg,l_param STRING                                       

   #---FUN-B70083---start-----
   #為防止參數資料檔案太過於老舊,造成參數資料載入失敗,因此強制使用者操作p_base_data作業
   #且只需做一次就可以了
   FOR l_i = 1 TO tm_arr.getLength()
       IF tm_arr[l_i].base_data = "Y" AND g_list[l_i].has_built = "N" THEN   #FUN-B90135 增加是否已建立之判斷has_built = "N"
          CALL cl_err(NULL, "azz1194", 1)
          CALL cl_cmdrun_wait("p_base_data")
          EXIT FOR
       END IF
   END FOR

   #尋問是否操作重建ods schema動作
   IF g_psw.ods_rebuild = "N" AND g_ods_exist = "Y" THEN
      IF p_create_schema_conf("azz1193") THEN
         LET g_psw.ods_rebuild = "Y"
      ELSE
         LET g_psw.ods_rebuild = "N"
      END IF
      DISPLAY BY NAME g_psw.ods_rebuild
   END IF
   #---FUN-B70083---end-------
   
   IF NOT p_create_schema_before_build() THEN
      RETURN
   END IF

   LET g_msv_user = tmpsw.ed_msv_user CLIPPED #FUN-A70028
   LET g_msv_psw = p_create_schema_psw_decrypt(tmpsw.ed_msv_psw CLIPPED)

   LET g_ase_user = tmpsw.ed_ase_user CLIPPED #FUN-AA0052
   LET g_ase_psw = p_create_schema_psw_decrypt(tmpsw.ed_ase_psw CLIPPED) #FUN-AA0052

   #清除記錄檔.
   CALL g_log_arr.clear()
   CALL p_create_schema_refresh_log()
   DISPLAY NULL TO te10
   
   CALL g_log_list.clear()

   LET l_cont_flag = TRUE
   #開始建立Schema.
   FOR l_i=1 TO g_list.getLength()
      IF g_list[l_i].sel='Y' AND g_list[l_i].has_built='N' THEN
         IF l_cont_flag THEN
            LET tm.* = tm_arr[l_i].*
            CASE g_db_type #FUN-A70028
               WHEN "ORA"
                  LET g_azp03_1 = tm.azp03_1 CLIPPED
               WHEN "MSV"
                  LET g_azp03_1 = tm.ed_msv_sch CLIPPED
               #---FUN-AA0052---start-----
               WHEN "ASE"
                  LET g_azp03_1 = tm.ed_ase_sch CLIPPED
               #---FUN-AA0052---end-------
            END CASE
            DISPLAY "BEGIN:",g_azp03_1
            
            LET l_log_file = g_today_str,"_",g_azp03_1,".log"
            LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
            LET g_log_ch = base.Channel.create()
            CALL g_log_ch.openFile(l_log_path, "w") #因為牽涉很多FUNCTION,所以改成global變數.
            CALL g_log_ch.writeLine(l_log_path)
            
            #只要有新建立實體Schema,就需要重建ods的view.
            IF NOT l_ods_flag THEN
               IF g_list[l_i].is_virtual='N' AND g_psw.ods_rebuild = "Y" THEN   #FUN-B70083 add ods_rebuild欄位判斷
                  #---FUN-AA0052---start-----
                  #因為p_create_schema_syn_view_list()
                  #可能需在ods create zta_file & azwd_file的Synonym
                  #所以將底下的open log file搬到這裡來
                  LET l_log_file = g_today_str,"_ods.log"
                  LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
                  LET g_ods_ch = base.Channel.create()
                  CALL g_ods_ch.openFile(l_log_path, "w")
                  CALL g_ods_ch.writeLine(l_log_path)
                  #---FUN-AA0052---end-------
                  
                  #先取得ods的table清單,因為在建立過程中,需要先針對實體Schema設定權限給ods.
                  CALL p_create_schema_ods_view_list()
                  LET l_ods_flag = TRUE
               END IF
            END IF
            
            IF NOT l_virtual_flag THEN
               IF g_list[l_i].is_virtual='Y' THEN
                  #取得虛擬Schema的Synonym和View清單.   
                  CALL p_create_schema_syn_view_list()
                  LET l_virtual_flag = TRUE
               END IF
            END IF
            
            IF l_tmp_idx=0 THEN
               LET l_tmp_idx = l_i #這裡只是為了最後資料的索引.
            END IF
            
            LET g_idx = l_i
            CALL p_create_schema_build_this() RETURNING l_cont_flag
            IF l_cont_flag THEN
               CALL p_create_schema_set_log()
               CALL g_log_ch.writeLine("END:" || g_azp03_1)
               #CALL g_log_ch.close()   #FUN-B70083 mark  因為要記錄最後執行記錄的訊息視窗,移到最下面再close
               DISPLAY "END:",g_azp03_1
            ELSE
               CALL g_log_ch.close()

               LET l_err_msg = cl_getmsg("azz1015", g_lang),"\n",p_create_schema_err_log_list() #FUN-9C0157
               LET l_log_file = "createsch_",g_azp03_1,".log"
               LET l_param = g_azp03_1,"|",l_log_file
               CALL cl_err_msg(l_err_msg,"azz1018",l_param,10)
               DISPLAY l_err_msg #除了顯現錯誤訊息視窗外,也要在console顯現訊息,避免使用者忘記將錯誤訊息抄寫下來.
               DISPLAY cl_getmsg_parm("azz1018", g_lang, l_param)
               
               EXIT PROGRAM #建立Schema都已經出錯了,應該要排除問題後再重新執行程式.
            END IF
         END IF
      END IF
   END FOR 

   #會執行到這裡的話,表示l_cont_flag一定是TRUE.
   #只需要在執行最後執行ods view的重建即可.
   IF l_ods_flag THEN   	  
      #---FUN-AA0052---start-----
      #因為上面的p_create_schema_syn_view_list()
      #可能需在ods create zta_file & azwd_file的Synonym
      #所以將這裡的open log file搬到上面去,此段就mark
      #LET l_log_file = g_today_str,"_ods.log"
      #LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
      #LET g_ods_ch = base.Channel.create()
      #CALL g_ods_ch.openFile(l_log_path, "w")
      #CALL g_ods_ch.writeLine(l_log_path)
      #---FUN-AA0052---end-------

      CALL p_create_schema_log_list(l_log_file)
      CALL cl_progress_bar(5) #5個流程
      CALL cl_progressing("Step 1(ods):begin to create ods")
      CALL p_create_schema_create_ods_view()
      CALL p_create_schema_set_ods_log()

      CALL g_ods_ch.close()
   END IF

   LET g_idx = l_tmp_idx #重設g_idx
   CALL p_create_schema_refresh_log()
   CALL p_create_schema_end_info("azz1014", NULL)
   CALL g_log_ch.close()   #FUN-B70083
END FUNCTION

#Schema建立前的檢查.
PRIVATE FUNCTION p_create_schema_before_build()
   DEFINE l_i,l_j SMALLINT,
          l_flag BOOLEAN,
          l_err_arg STRING,
          l_sch_str STRING,
          l_profile_ch base.Channel,
          l_line STRING,
          l_key STRING,
          l_cnt SMALLINT

   #實際的程式控制中,sel='Y'時,has_built一定是'N'.
   #判斷是否有勾選.
   FOR l_i=1 TO g_list.getLength()
      IF g_list[l_i].sel='Y' AND g_list[l_i].has_built='N' THEN
         LET l_flag = TRUE
         EXIT FOR
      END IF
   END FOR 

   IF NOT l_flag THEN
      CALL cl_err_msg(null,"azz1021",null,10)
      RETURN FALSE
   END IF 

   #到了這裡,l_flag一定是TRUE.
   #判斷所選擇的實體Schema建立順序是否正確.
   FOR l_i=1 TO g_list.getLength()
      IF g_list[l_i].sel='Y' AND g_list[l_i].is_virtual='N' AND g_list[l_i].has_built='N' THEN
         LET l_flag = FALSE #一開始判斷前就預設為FALSE
         #建立實體Schema之前,要先判斷法人Schema是否已建立.
         IF cl_chk_schema_has_built(g_list[l_i].legal_db) THEN
            LET l_flag = TRUE
            CONTINUE FOR
         ELSE
            #未建立的話,再判斷是否有勾選正要建立.
            FOR l_j=1 TO l_i #連當下這筆也要判斷.
               IF g_list[l_j].sel='Y' AND g_list[l_j].schema CLIPPED=g_list[l_i].legal_db CLIPPED THEN
                  LET l_flag = TRUE
                  EXIT FOR
               END IF
            END FOR

            IF NOT l_flag THEN #有一筆資料不對的話,就跳出來.
               LET l_err_arg = g_list[l_i].schema CLIPPED,"|",g_list[l_i].legal_db CLIPPED
               EXIT FOR
            END IF
         END IF
      END IF
   END FOR

   IF NOT l_flag THEN
      CALL cl_err_msg(null,"azz1028",l_err_arg,10)
      RETURN FALSE
   END IF

   #到了這裡,l_flag一定是TRUE.
   #判斷所選擇的虛擬Schema建立順序是否正確.
   FOR l_i=1 TO g_list.getLength()
      IF g_list[l_i].sel='Y' AND g_list[l_i].is_virtual='Y' AND g_list[l_i].has_built='N' THEN
         LET l_flag = FALSE #一開始判斷前就預設為FALSE
         #建立虛擬Schema之前,要先確認對應的實體Schema是否已建立.
         IF cl_chk_schema_has_built(g_list[l_i].target_schema) THEN
            LET l_flag = TRUE
            CONTINUE FOR
         ELSE
            #未建立的話,再判斷是否有勾選正要建立.
            FOR l_j=1 TO l_i-1 #和法人Shema的判斷不同
               IF g_list[l_j].sel='Y' AND g_list[l_j].schema CLIPPED=g_list[l_i].target_schema CLIPPED THEN
                  LET l_flag = TRUE
                  EXIT FOR
               END IF
            END FOR

            IF NOT l_flag THEN #有一筆資料不對的話,就跳出來.
               LET l_err_arg = g_list[l_i].schema CLIPPED,"|",g_list[l_i].target_schema CLIPPED
               EXIT FOR
            END IF
         END IF
      END IF
   END FOR

   IF NOT l_flag THEN
      CALL cl_err_msg(null,"azz1017",l_err_arg,10)
      RETURN FALSE
   END IF

   #到了這裡,l_flag一定是TRUE.
   #檢查要建立的Schema是否已經有設定資料存在FGLPROFILE內.
   LET l_profile_ch = base.Channel.create()
   FOR l_i=1 TO g_list.getLength()
      IF g_list[l_i].sel='Y' AND g_list[l_i].has_built='N' THEN
         CALL l_profile_ch.openFile(FGL_GETENV("FGLPROFILE"), "r") #因為FGLPROFILE內的設定沒有順序性,因此一定得檢查一個Schema時就重新讀取.
         LET l_key = "dbi.database.",DOWNSHIFT(g_list[l_i].schema CLIPPED),".source"
         
         WHILE TRUE
            LET l_line = l_profile_ch.readLine()
         
            IF l_profile_ch.isEof() THEN
               EXIT WHILE
            END IF
         
            LET l_line = l_line.trim()
            LET l_line = l_line.toLowerCase()

            IF l_line.getCharAt(1)<>"#" THEN
               IF l_line.getIndexOf(l_key, 1)>0 THEN
                  IF cl_null(l_sch_str) THEN
                     LET l_sch_str = g_list[l_i].schema CLIPPED
                  ELSE
                     LET l_sch_str = l_sch_str,",",g_list[l_i].schema CLIPPED
                  END IF
               
                  EXIT WHILE
               END IF
            END IF
         END WHILE

         CALL l_profile_ch.close()
      END IF
   END FOR

   IF NOT cl_null(l_sch_str) THEN
      CALL cl_err_msg(null,"azz1027",l_sch_str,10)
      RETURN FALSE
   END IF

   #到了這裡,l_flag一定是TRUE.
   #檢查要建立的Schema是否已經有zta的資料,有的話要先清除,不能在建立過程才判斷,因為有可能資料是不對的,如果就直接避開新增的話,原始的錯誤資料就沒有機會更新了.
   #此段經過討論不需事先檢查
   #FOR l_i=1 TO g_list.getLength()
   #   IF g_list[l_i].sel='Y' AND g_list[l_i].has_built='N' THEN
   #      SELECT COUNT(*) INTO l_cnt FROM zta_file WHERE zta02=LOWER(g_list[l_i].schema)
   #      IF l_cnt>0 THEN
   #         IF cl_null(l_sch_str) THEN
   #            LET l_sch_str = g_list[l_i].schema CLIPPED
   #         ELSE
   #            LET l_sch_str = l_sch_str,",",g_list[l_i].schema CLIPPED
   #         END IF
   #      END IF
   #   END IF
   #END FOR

   #IF NOT cl_null(l_sch_str) THEN
   #   CALL cl_err_msg(null,"azz1031",l_sch_str,10)
   #   RETURN FALSE
   #END IF

   RETURN TRUE
END FUNCTION

#先取得ods的table清單,因為在建立過程中,需要先針對實體Schema設定權限給ods:只需要建立一次即可,可共用.
PRIVATE FUNCTION p_create_schema_ods_view_list()
   DEFINE l_table_sql STRING,
          l_i INTEGER

   CALL g_log_ch.writeLine("ods schema:view list in preparation")
   DISPLAY "ods schema:view list in preparation"

   CALL g_ods_arr.clear()
   CALL g_ods_syn.clear()
   
   CLOSE DATABASE 
   DATABASE ods  
   
   #FUN-A70115 取得Synonym到ds的Table清單
   IF g_db_type="MSV" OR g_db_type="ASE" OR g_db_type="ORA" THEN   #FUN-AA0052增加g_db_type="ASE"判斷  #FUN-BB0118 增加ORA 
      CALL create_synonym( "zta_file")
      CALL create_synonym( "azwd_file")
   END IF
   
   LET l_table_sql = "SELECT zta01 FROM zta_file", #zta09='Z'表示Synonym for ds.
                     " WHERE zta02='ds' AND zta07='T' AND zta09='Z'", #AIN不剔除,這樣清單才會比較清楚與正確.
                     " ORDER BY 1" 
                     
   DECLARE ods_synonym_cs CURSOR FROM l_table_sql
   LET l_i = 1
   FOREACH ods_synonym_cs INTO g_ods_syn[l_i]
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF

      LET l_i = l_i + 1
   END FOREACH
   CALL g_ods_syn.deleteElement(l_i)

   #此段SQL和p_create_schema_grant_ods()內取得Multi-db的SQL相同,只是對象不同而已.
   #Begin:FUN-A50080
   #CASE g_db_type #FUN-A70028
   #   WHEN "ORA"
   #      LET l_table_sql = "SELECT gat01 FROM gat_file",
   #                        " INNER JOIN zta_file ON zta01=gat01 AND zta02='ds' AND zta07='T'",
   #                        " WHERE gat02='",g_lang,"' AND gat06<>'AIN'",
   #                        "   AND NOT EXISTS (SELECT synonym_name FROM user_synonyms WHERE synonym_name=UPPER(gat01))",
   #                        " ORDER BY 1" 
   #   WHEN "MSV"
   #      LET l_table_sql = "SELECT gat01 FROM gat_file",
   #                        " INNER JOIN zta_file ON zta01=gat01 AND zta02='ds' AND zta07='T'",
   #                        " WHERE gat02='",g_lang,"' AND gat06<>'AIN'",
   #                        "   AND NOT EXISTS (SELECT name FROM sys.synonyms WHERE name=LOWER(gat01))",
   #                        " ORDER BY 1"
   #END CASE
   #這是最標準的ods清單.
   LET l_table_sql = "SELECT zta01 FROM zta_file", #zta09='Z'表示Synonym for ds.
                     " WHERE zta02='ds' AND zta07='T' AND zta09<>'Z'", #AIN不剔除,這樣清單才會比較清楚與正確.
                     " ORDER BY 1" 
   #End:FUN-A50080
   DECLARE ods_table_cs CURSOR FROM l_table_sql
   LET l_i = 1
   FOREACH ods_table_cs INTO g_ods_arr[l_i]
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF

      LET l_i = l_i + 1
   END FOREACH
   CALL g_ods_arr.deleteElement(l_i)

   CLOSE DATABASE 

   DATABASE g_dbs 
END FUNCTION

#取得虛擬Schema所需要的View與Schema清單:只需要建立一次即可,可共用.
PRIVATE FUNCTION p_create_schema_syn_view_list()
   DEFINE l_j SMALLINT,
          l_virtual_flag BOOLEAN
   DEFINE l_view_sql STRING,
          l_v SMALLINT
   DEFINE l_syn_sql STRING,
          l_s SMALLINT

   CALL g_log_ch.writeLine("virtual schema:synonym list in preparation")
   DISPLAY "virtual Schema:synonym list in preparation"
   
   CALL g_syn_arr.clear()
   CALL g_view_arr.clear()

   LET l_syn_sql = cl_get_syn_sql("ds")
   DECLARE syn_cs CURSOR FROM l_syn_sql
   LET l_s = 1
   FOREACH syn_cs INTO g_syn_arr[l_s].*     #FUN-A70029
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF
   
      LET l_s = l_s + 1
   END FOREACH
   CALL g_syn_arr.deleteElement(l_s)

   CALL g_log_ch.writeLine("virtual schema:view list in preparation")
   DISPLAY "virtual schema:view list in preparation"

   LET l_view_sql = cl_get_view_sql("ds")
   DECLARE view_cs CURSOR FROM l_view_sql
   #FOREACH內本來是用l_v+1來將資料塞入陣列內,但是最後陣列還是對多一筆空白,所以乾脆就用比較簡單的做法來設定.
   LET l_v = 1
   FOREACH view_cs INTO g_view_arr[l_v]
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF
   
      LET l_v = l_v + 1
   END FOREACH
   CALL g_view_arr.deleteElement(l_v)
END FUNCTION

#逐筆資料建立Schema.
PRIVATE FUNCTION p_create_schema_build_this()
   DEFINE l_cmd STRING 
   DEFINE l_type LIKE type_file.chr1
   DEFINE l_cnt SMALLINT
   DEFINE l_ed4_2,l_ed4_4,l_ed4_6,l_ed4,l_ed4_1,l_ed4_9 STRING
   DEFINE l_server_ip LIKE azp_file.azp20 #FUN-A70028
   DEFINE l_msg STRING
   DEFINE l_log STRING
   DEFINE l_azwd_cnt SMALLINT #FUN-A40004
   DEFINE l_instance STRING #FUN-AA0052
   DEFINE l_ref_sch LIKE azp_file.azp03 #FUN-AA0052

   #createsch的四種建立方式:FUN-A30088
   #1:參考ds:單純建立user(沒有Table Schema)
   #2:參考ds:建立user與Table Schema(沒有資料)
   #3:參考ds:建立user與Table Schema(包含資料)
   #4:參考所輸入的user,並包含資料

   IF g_list[g_idx].is_virtual='Y' THEN
      #虛擬資料庫都是透過第一種方式建立:只建立user.
      LET l_type = '1'
   ELSE
      IF tm.demo = 'N' AND tm.chk_msv_demo = 'N' AND tm.chk_ase_demo = 'N' THEN   #FUN-AA0052 增加msv與sybase的是否需要demo data的判斷
         LET l_type = '2'
      ELSE 
         #本來預設都是'4',但是因為ds不需要Synonym到ds(shell已經寫死),所以還是得分成兩種.
         CASE g_db_type #FUN-A70028
            WHEN "ORA"
               IF tm.azp03_2 CLIPPED='ds' THEN
                  LET l_type = '3' 
               ELSE
                  LET l_type = '4'
               END IF
            WHEN "MSV"
               IF tm.ed_msv_ref_sch CLIPPED='ds' THEN
                  LET l_type = '3' 
               ELSE
                  LET l_type = '4'
               END IF
            #---FUN-AA0052---start-----
            WHEN "ASE"
               IF tm.ed_ase_ref_sch CLIPPED='ds' THEN
                  LET l_type = '3' 
               ELSE
                  LET l_type = '4'
               END IF
            #---FUN-AA0052---end-------
         END CASE
      END IF  
   END IF
   
   IF g_list[g_idx].is_virtual='Y' THEN
      CALL cl_progress_bar(3)
   ELSE
      CALL cl_progress_bar(2)
   END IF

   CALL p_create_schema_progress("Step 1(%1):build schema")
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         #---FUN-AB0017---start-----
         IF tm.ed_ora_device IS NULL THEN
            LET tm.ed_ora_device = 'dbs1'
         END IF
         #---FUN-AB0017---end-------
         
         LET l_ed4_2 = p_create_schema_psw_decrypt(tmpsw.ed4_2 CLIPPED)
         LET l_ed4_4 = p_create_schema_psw_decrypt(tmpsw.ed4_4 CLIPPED)
         LET l_ed4_6 = p_create_schema_psw_decrypt(tmpsw.ed4_6 CLIPPED)
         LET l_ed4 = p_create_schema_psw_decrypt(tm.ed4 CLIPPED)
         LET l_ed4_1 = p_create_schema_psw_decrypt(tm.ed4_1 CLIPPED)
         LET l_ed4_9 = p_create_schema_psw_decrypt(tm.ed4_9 CLIPPED)
         LET l_cmd = "createsch ",g_azp03_1," ",l_type CLIPPED," ", #FUN-9C0157
                                  l_ed4," ",l_ed4_1," ",
                                  l_ed4_2," ",l_ed4_2," ",
                                  l_ed4_4," ",l_ed4_4," ",
                                  l_ed4_6," ",l_ed4_6
         
         IF l_type="4" THEN
            LET l_cmd = l_cmd CLIPPED," ",tm.azp03_2 CLIPPED," ",l_ed4_9," ",l_ed4_9
         END IF
      WHEN "MSV"
         SELECT distinct azp20 INTO l_server_ip FROM azp_file WHERE azp03='ds' #應該會有ds的資料吧.
         IF SQLCA.SQLCODE THEN
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
            CALL g_log_ch.writeLine(l_msg)
            DISPLAY l_msg
            RETURN FALSE
         END IF

         LET l_cmd = "createsch ",g_azp03_1," ",l_type CLIPPED," ",
                                  g_msv_user," ",g_msv_psw," ",
                                  l_server_ip," ",tm.ed_msv_ref_sch CLIPPED
         LET g_msv_db = FGL_GETENV("MSSQLAREA"),"_" ,g_azp03_1   #FUN-A70029
      #---FUN-AA0052---start-----
      WHEN "ASE"
         LET l_instance = FGL_GETENV("DSQUERY")

         IF tm.ed_ase_ref_sch IS NULL THEN 
            LET l_ref_sch = 'ds'
         ELSE
            LET l_ref_sch = tm.ed_ase_ref_sch
         END IF

         #---FUN-AB0017---start-----
         IF tm.ed_ase_device IS NULL THEN
            LET tm.ed_ase_device = 'dbs1'
         END IF
         LET g_azp03_1 = g_azp03_1, ":", tm.ed_ase_device
         #---FUN-AB0017---end-------

         LET l_cmd = "createsch ",g_azp03_1," ",l_type CLIPPED," ",
                                  g_ase_user," ",g_ase_psw," ",
                                  l_instance," ",l_ref_sch CLIPPED, " ",
                                  g_list[g_idx].is_virtual CLIPPED, " > ",
                                  g_tmpdir,"/createsch_",g_azp03_1,".log"
      #---FUN-AA0052---end-------
   END CASE
 
   LET l_msg = g_azp03_1,":creating schema"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
   TRY

      RUN l_cmd
      LET l_log = "createsch_",g_azp03_1,".log"
      IF p_create_schema_log_has_err(l_log) THEN
         RETURN FALSE
      END IF

      #FUN-A40004:實體Schema建立後,需要新增資訊到azwd_file內,可讓ods重建view的時候,也包含此Schema的資料.
      IF g_list[g_idx].is_virtual='N' THEN
         LET l_msg = g_azp03_1,":insert into azwd_file"
         CALL g_log_ch.writeLine(l_msg)
         DISPLAY l_msg

         CASE g_db_type #FUN-A70028
            WHEN "ORA"
               SELECT COUNT(*) INTO l_azwd_cnt FROM azwd_file WHERE azwd01=tm.azp03_1
            WHEN "MSV"
               SELECT COUNT(*) INTO l_azwd_cnt FROM azwd_file WHERE azwd01=tm.ed_msv_sch
            #---FUN-AA0052---start-----
            WHEN "ASE"
               SELECT COUNT(*) INTO l_azwd_cnt FROM azwd_file WHERE azwd01=tm.ed_ase_sch
            #---FUN-AA0052---end-------
         END CASE
         IF l_azwd_cnt=0 THEN
            CASE g_db_type #FUN-A70028
               WHEN "ORA"
                  INSERT INTO azwd_file (azwd01,azwddate,azwduser,azwdgrup,azwdmodu,azwdoriu,azwdorig)
                                 VALUES (tm.azp03_1,g_today,g_user,g_grup,NULL,g_user,g_grup)
               WHEN "MSV"
                  INSERT INTO azwd_file (azwd01,azwddate,azwduser,azwdgrup,azwdmodu,azwdoriu,azwdorig)
                                 VALUES (tm.ed_msv_sch,g_today,g_user,g_grup,NULL,g_user,g_grup)
               #---FUN-AA0052---start-----
               WHEN "ASE"
                  INSERT INTO azwd_file (azwd01,azwddate,azwduser,azwdgrup,azwdmodu,azwdoriu,azwdorig)
                                 VALUES (tm.ed_ase_sch,g_today,g_user,g_grup,NULL,g_user,g_grup)
               #---FUN-AA0052---end-------
            END CASE
            IF SQLCA.SQLCODE THEN
               LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
               CALL g_log_ch.writeLine(l_msg)
            END IF
         END IF
      END IF

      #有需要建立參考資料時,要將參數檔的資料更新為標準出貨資料.
      #---FUN-B70083---start-----
      #因為將載入行業別參數資料與匯入demo data功能切割開來,所以不再用以下判斷式判斷，下面這行mark
      #IF tm.demo='Y' OR tm.chk_msv_demo = 'Y' OR tm.chk_ase_demo = 'Y' THEN   #FUN-AA0052增加是否需要Demo Data的判斷
      IF tm.base_data = "Y" THEN
      #---FUN-B70083---end-------
         CALL p_create_schema_load()
      ELSE 
         #虛擬Schema絕對不需要參考.
         IF g_list[g_idx].is_virtual='Y' THEN
            CALL p_create_schema_virtual_syn_view()
         END IF
      END IF

      IF g_list[g_idx].is_virtual='N' THEN
         CALL p_create_schema_default_value()    #FUN-B70083 新建實體DB時將相關欄位Update成新的營運中心代碼
         
         #實體Schema且不是法人db的話,就要設定財務模組的synonym.
         #一定要在設定完synonym之後,才寫入zta_file,所以不能透過zta_file來取得目前Schema的相關設定.         
         IF g_azp03_1<>g_list[g_idx].legal_db CLIPPED THEN         	  
            CALL p_create_schema_syn_to_legal()
         END IF
         #新建的實體Schema需要設定grant select,index to ods,這樣ods才有辦法建立view.
         IF g_db_type="ORA" AND g_psw.ods_rebuild = "Y" THEN #FUN-A70028   #FUN-B70083 add ods_rebuild欄位判斷
            CALL p_create_schema_grant_ods()
         END IF
         CALL p_create_schema_progress("Step 2(%1):insert zta_file data")  #FUN-A70115
      ELSE
         CALL p_create_schema_progress("Step 3(%1):insert zta_file data")  #FUN-A70115       
      END IF

      #FUN-A70115   
      CASE g_db_type #FUN-A70028 
         WHEN "ORA"
            SELECT COUNT(*) INTO l_cnt FROM zta_file WHERE zta02=LOWER(tm.azp03_1)
         WHEN "MSV"
            SELECT COUNT(*) INTO l_cnt FROM zta_file WHERE zta02=tm.ed_msv_sch
         #---FUN-AA0052---start-----
         WHEN "ASE"
            SELECT COUNT(*) INTO l_cnt FROM zta_file WHERE zta02=tm.ed_ase_sch
         #---FUN-AA0052---end-------
      END CASE   
         
      IF l_cnt=0 THEN
         #新增資料到zta_file
         LET l_msg = g_azp03_1,":insert into zta_file"
         CALL g_log_ch.writeLine(l_msg)
         DISPLAY l_msg
         
         LET l_cmd = "p_zta 'Y' 'ztaimport' '",g_azp03_1,"' '2'"
         
         CALL g_log_ch.writeLine(l_cmd)
         DISPLAY l_cmd
         
         CALL cl_cmdrun_wait(l_cmd)
         
         LET l_msg = g_azp03_1,":insert into zta_file finish"
         CALL g_log_ch.writeLine(l_msg)
         DISPLAY l_msg
      END IF

      #已經建立的Schema就不能勾選.
      LET g_list[g_idx].sel = 'N'
      LET g_list[g_idx].has_built = 'Y'
      DISPLAY ARRAY g_list TO s_tb1.*
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
   CATCH
      #createsch不會跑到這邊.
      LET l_msg = g_azp03_1,":failure to create the schema"
      CALL g_log_ch.writeLine(l_msg)
      DISPLAY l_msg
      RETURN FALSE
   END TRY
   RETURN TRUE
END FUNCTION

#檢查log檔是否有錯誤.
PRIVATE FUNCTION p_create_schema_log_has_err(p_log)
   DEFINE p_log,l_path STRING,
          l_log_ch base.Channel,
          l_line STRING,
          l_fail_flag BOOLEAN

   #解析log檔,判斷是否有錯誤.
   LET l_path = os.Path.join(g_tmpdir, p_log)
   IF os.Path.exists(l_path) THEN
      LET l_log_ch = base.Channel.create()
      CALL l_log_ch.openFile(l_path, "r")
      
      WHILE TRUE
         LET l_line = l_log_ch.readLine()
      
         IF l_log_ch.isEof() THEN
            EXIT WHILE
         END IF
      
         IF l_line.getIndexOf("ERROR", 1)>0 THEN
            LET l_fail_flag = TRUE
            EXIT WHILE
         END IF
      END WHILE

      CALL l_log_ch.close()
   END IF

   RETURN l_fail_flag
END FUNCTION

#載入業別的出貨標準參數資料.
PRIVATE FUNCTION p_create_schema_load()
   DEFINE l_topdir    STRING,                                       
          l_flst_dir  STRING,
          l_ind_dir   STRING,
          l_ind_flag  SMALLINT, 
          l_ind_file  STRING,
          l_ind_table STRING,
          l_flst_file STRING,
          l_flst_ch   base.Channel,
          l_flst_str  STRING
   DEFINE l_del_cmd   STRING 
   DEFINE l_ins_sql   STRING,
          l_ind_path  STRING
   DEFINE l_file STRING,
          l_path STRING,                                       
          l_ch base.Channel
   DEFINE l_msg STRING
   DEFINE l_cmd STRING
          
   LET l_msg = g_azp03_1,":loading base data"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
   
   LET l_file = g_today_str,"_",g_azp03_1,"_load.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_path, "w")
   CALL l_ch.writeLine(l_path)
          
   CALL p_create_schema_log_list(l_file)

   LET l_topdir = FGL_GETENV("TOP")
   LET l_flst_dir = l_topdir,'/doc/def_data/flst/' #Table的欄位資料存放目錄
          
   #CASE tm.ind
   CASE g_list[g_idx].ind #FUN-9C0157
      WHEN 'std' 
         LET l_ind_dir = l_topdir,'/doc/def_data/std/'
      WHEN 'icd' 
         LET l_ind_dir = l_topdir,'/doc/def_data/icd/'
      WHEN 'slk' 
         LET l_ind_dir = l_topdir,'/doc/def_data/slk/'
   END CASE
           
   LET l_ind_flag = os.Path.diropen(l_ind_dir)

   #---FUN-AA0052---start-----   
   #因為目前在Sybase裡LOAD FROM不支援在table前面加table owner
   #所以這裡先切換DB到g_azp03_1
   IF g_db_type = "ASE" THEN
      CONNECT TO g_azp03_1 USER g_ase_user USING g_ase_psw
   END IF
   #---FUN-AA0052---start-----  
 
   WHILE l_ind_flag > 0
      LET l_ind_file = os.Path.dirnext(l_ind_flag)
 
      IF l_ind_file IS NULL THEN 
         EXIT WHILE
      END IF

      IF l_ind_file == "." OR l_ind_file == ".." THEN
         CONTINUE WHILE
      END IF

      LET l_ind_table = os.Path.rootname(l_ind_file)

      LET l_flst_file = l_flst_dir,l_ind_table,".flst" #Table的欄位資料存放檔案
      LET l_flst_ch = base.Channel.create()
      CALL l_flst_ch.openFile(l_flst_file, "r")
      LET l_flst_str = l_flst_ch.readLine() #欄位資料只會有一筆
      
      #---FUN-AA0052---start-----   
      #因為ASE SQL語法會分大小寫,所以這裡要轉成小寫  
      IF g_db_type = "ASE" THEN
         LET l_flst_str = DOWNSHIFT(l_flst_str)
      END IF
      #---FUN-AA0052---start-----     
      CALL l_flst_ch.close()

      #刪除檔案
      LET l_del_cmd = "DELETE FROM ",s_dbstring(g_azp03_1),l_ind_table   
      TRY
         CALL l_ch.writeLine(l_del_cmd)
         EXECUTE IMMEDIATE l_del_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
         CONTINUE WHILE
      END TRY
 
      #載入檔案
      LET l_ind_path = os.Path.join(l_ind_dir, l_ind_file)
      TRY
         IF g_db_type = "MSV" THEN
            LET l_ins_sql = "INSERT INTO ",l_ind_table
            LET l_cmd = "load ",g_azp03_1 , " " ,l_ind_table , " " , l_ind_path
            CALL  run_msv_sql(l_cmd) RETURNING l_msg
            
            IF NOT cl_null(l_msg) THEN 
               CALL l_ch.writeLine(l_msg)
            END IF
         ELSE
            LET l_ins_sql = "INSERT INTO ",s_dbstring(g_azp03_1),l_ind_table," (",l_flst_str,")"
            #---FUN-AA0052---start-----   
            #因為目前在Sybase裡LOAD FROM不支援在table前面加table owner
            #所以前面已先將DB切到g_azp03_1,因此這裡只需要直接INSERT INTO [table]即可,不需要再接DB Owner在前面
            IF g_db_type = "ASE" THEN
               LET l_ins_sql = "INSERT INTO ",l_ind_table," (",l_flst_str,")"
            END IF
            #---FUN-AA0052---start-----     
            CALL l_ch.writeLine(l_ins_sql)
            LOAD FROM l_ind_path l_ins_sql
         END IF
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
   END WHILE

   DISCONNECT CURRENT     #FUN-AA0052
   DATABASE g_dbs         #FUN-AA0052

   CALL l_ch.close()

   CALL os.Path.dirclose(l_ind_flag)

   LET l_msg = g_azp03_1,":load base data finish"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
END FUNCTION 

#虛擬Schema需要建立View與Synonym.
#建立View失敗的原因可能有:
#1.新建的Schema資訊沒有在fglprofile內.
#2.sid_file,azwa_file權限問題.
#3.要建立View的Table本身權限問題.
PRIVATE FUNCTION p_create_schema_virtual_syn_view()
   DEFINE l_source STRING
   DEFINE l_virtual_sch LIKE azw_file.azw06,
          l_real_sch LIKE azw_file.azw05
   DEFINE l_grant_cmd STRING
   DEFINE l_v,l_s INTEGER
   DEFINE l_table_name,l_plant_field,l_cmd STRING
   DEFINE l_file STRING,
          l_path STRING,                                       
          l_ch base.Channel
   DEFINE l_i    INTEGER,
          l_cnt  INTEGER,
          l_virtual_psw,l_real_psw STRING, 
          l_exist_flag BOOLEAN #為了決定要如何連線
   DEFINE l_msg STRING
   DEFINE l_msv_path  STRING
   DEFINE l_sql       STRING

   LET l_virtual_sch = g_azp03_1
   
   LET l_file = g_today_str,"_",g_azp03_1,"_syn.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_path, "w")
   CALL l_ch.writeLine(l_path)

   CALL p_create_schema_log_list(l_file)

   #取得FGLPROFILE內的設定.
   #LET l_source = "dbi.database.",l_real_sch,".source"
   #LET l_source = FGL_GETRESOURCE(l_source)
   LET l_source = FGL_GETRESOURCE("dbi.database.ds.source") #FUN-A30088

   #要切換到虛擬Schema才可以建立View與Synonym.
   CLOSE DATABASE

   CALL p_create_schema_progress("Step 2(%1):create synonyms and view") #FUN-A70115
   #Begin:建立Synonym
   #虛擬Schema一定是新建的.
   LET l_msg = g_azp03_1,":creating synonyms"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   LET l_msg = "CONNECT TO ",l_virtual_sch
   CALL l_ch.writeLine(l_msg)
   
   IF g_rebuild = "Y" THEN    #FUN-A70115
      LET l_real_sch = g_real_db   	  
   ELSE
      LET l_real_sch = DOWNSHIFT(g_list[g_idx].target_schema CLIPPED)
      LET l_virtual_psw = p_create_schema_psw_decrypt(tm.ed4)
   END IF

   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         IF g_rebuild = "Y" THEN 
            CONNECT TO l_virtual_sch
         ELSE
            CONNECT TO l_source USER l_virtual_sch USING l_virtual_psw 
         END IF
      WHEN "MSV"
         CONNECT TO "ds"  AS "view_db_msv"
         #FUN-A80140
         LET l_sql = "SELECT COUNT(*) FROM ",g_msv_db,".sys.synonyms WHERE name= ? " 
         PREPARE syn_pre1 FROM l_sql 
      #---FUN-AA0052---start-----     
      WHEN "ASE"
         CONNECT TO l_virtual_sch USER g_ase_user USING g_ase_psw
      #---FUN-AA0052---end-------
   END CASE

   FOR l_s=1 TO g_syn_arr.getLength() 
      LET l_table_name = g_syn_arr[l_s].zta01 CLIPPED
        
      IF g_rebuild = "Y" THEN 
         CASE g_db_type
            WHEN "ORA"
               SELECT COUNT(*) INTO l_cnt FROM user_synonyms WHERE synonym_name=upper(g_syn_arr[l_s].zta01)
            WHEN "MSV" #FUN-A80140
               EXECUTE syn_pre1 USING g_syn_arr[l_s].zta01 INTO l_cnt
            #---FUN-AA0052---start-----  
            WHEN "ASE" 
               SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE NAME = lower(g_syn_arr[l_s].zta01) AND TYPE = 'V'
            #---FUN-AA0052---end-------
         END CASE
         
         IF l_cnt > 0 THEN 
            CONTINUE FOR #如果存在就不用create synonym
         END IF
      END IF
    
      IF g_syn_arr[l_s].zta09= "Z" AND g_db_type="MSV" THEN #FUN-A70029 SQL SERVER 需要定義ds
         LET l_cmd = "CREATE SYNONYM ",l_table_name, " for ",s_dbstring("ds"),l_table_name
      ELSE
         #---FUN-AA0052---start-----  
         #因為Sybase無法Create Synonym,只有View物件,改寫此處CREATE SYNONYM語法
         #LET l_cmd = "CREATE SYNONYM ",l_table_name, " for ",s_dbstring(l_real_sch CLIPPED),l_table_name
         CASE g_db_type
            WHEN "ORA"
               LET l_cmd = "CREATE SYNONYM ",l_table_name, " for ",s_dbstring(l_real_sch CLIPPED),l_table_name
            WHEN "ASE" 
               LET l_cmd = "CREATE VIEW ",l_table_name, " AS SELECT * FROM  ",s_dbstring(l_real_sch CLIPPED),l_table_name
         END CASE
         #---FUN-AA0052---end-------
      END IF
      TRY
         CALL l_ch.writeLine(l_cmd)
         LET l_cmd = create_msv_prefix(l_cmd) 
         EXECUTE IMMEDIATE l_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
   END FOR

   CALL l_ch.close()

   DISCONNECT CURRENT

   LET l_msg = g_azp03_1,":create synonyms finish"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
   #End:建立Synonym

   #Begin:建立View
   LET l_msg = g_azp03_1,":creating views"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   LET l_file = g_today_str,"_",g_azp03_1,"_view.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_path, "w")
   CALL l_ch.writeLine(l_path)

   CALL p_create_schema_log_list(l_file)

   IF g_db_type="ORA" THEN #FUN-A70028
      #要先切換到ds才可以將sid_file,azwa_file的權限設定給虛擬Schema.
      CALL l_ch.writeLine("DATABASE ds")
      DATABASE ds
      
      LET l_grant_cmd = "GRANT SELECT,INDEX ON sid_file TO ",l_virtual_sch
      TRY
         CALL l_ch.writeLine(l_grant_cmd)
         EXECUTE IMMEDIATE l_grant_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
      
      #Begin:FUN-A50080
      #LET l_grant_cmd = "GRANT SELECT,INDEX ON azwa_file TO ",l_virtual_sch
      #TRY
      #   CALL l_ch.writeLine(l_grant_cmd)
      #   EXECUTE IMMEDIATE l_grant_cmd
      #CATCH
      #   LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
      #   CALL l_ch.writeLine(l_msg)
      #END TRY
      #End:FUN-A50080
      
      CLOSE DATABASE
   END IF

   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         IF g_rebuild = "Y" THEN  #FUN-A70115
            CONNECT TO l_real_sch
         ELSE
         #這裡的前提一定是:實體Schema建立後,才會建立虛擬Schema;底下只是判斷此程式是否有重新開啟過,所以只能從畫面上的資料來查.
         #要切換到虛擬Schema對應的實體Schema,才可以將View的來源Table權限設定給虛擬Schema,這樣View才可以建立.
         #同時建立實體Schema與虛擬Schema時,會因為FGLPROFILE沒有重新讀取而造成連線問題.
            FOR l_i=1 TO g_idx-1
               IF tm_arr[l_i].azp03_1 CLIPPED=l_real_sch THEN
                  LET l_exist_flag = TRUE
                  LET l_real_psw = p_create_schema_psw_decrypt(tm_arr[l_i].ed4)
                  EXIT FOR
               END IF
            END FOR
            
            LET l_msg = "CONNECT TO ",l_real_sch
            CALL l_ch.writeLine(l_msg)
            IF l_exist_flag THEN #實體Schema的資料還在畫面上,表示程式都還沒有關閉,亦即沒有重新讀取FGLPROFILE.
               CONNECT TO l_source USER l_real_sch USING l_real_psw
            ELSE
               CONNECT TO l_real_sch
            END IF
         END IF
      WHEN "MSV"
         CONNECT TO "ds" USER g_msv_user USING g_msv_psw
         LET g_real_msvdb = FGL_GETENV("MSSQLAREA"),"_",l_real_sch
      #---FUN-AA0052---start-----
      WHEN "ASE"
         CONNECT TO l_real_sch USER g_ase_user USING g_ase_psw
      #---FUN-AA0052---end-------
   END CASE 

   FOR l_v=1 TO g_view_arr.getLength() 
      LET l_table_name = g_view_arr[l_v] CLIPPED
      #LET l_plant_field = l_table_name.subString(1, l_table_name.getIndexOf('_', 1)-1),"plant"      #FUN-AB0017 mark #No.FUN-A20015 add
      LET l_plant_field = l_table_name.subString(1, l_table_name.getIndexOf('_file', 1)-1),"plant"   #FUN-AB0017
      CALL create_view_index(l_table_name, l_plant_field, l_ch)                                  #No.FUN-A20015 add

      IF g_db_type="ORA" THEN #FUN-A70028
         LET l_grant_cmd = "GRANT INSERT,SELECT,INDEX,DELETE,UPDATE ON ",l_table_name," TO ",l_virtual_sch

         TRY
            CALL l_ch.writeLine(l_grant_cmd)
            EXECUTE IMMEDIATE l_grant_cmd
         CATCH
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
            CALL l_ch.writeLine(l_msg)
         END TRY
      END IF
   END FOR

   DISCONNECT CURRENT
   #IF l_exist_flag THEN
   #   DISCONNECT CURRENT
   #ELSE
   #   CLOSE DATABASE
   #END IF

   LET l_msg = "CONNECT TO ",l_virtual_sch
   CALL l_ch.writeLine(l_msg)

   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         IF g_rebuild = "Y" THEN 
            CONNECT TO l_virtual_sch
            CALL p_create_schema_rebuild_view()
         ELSE
            CONNECT TO l_source USER l_virtual_sch USING l_virtual_psw
         END IF
      WHEN "MSV"
         #FUN-A80140
         IF g_rebuild = "Y" THEN 
            CONNECT TO l_virtual_sch
            CALL p_create_schema_rebuild_view()
         ELSE
            CONNECT TO "ds" USER g_msv_user USING g_msv_psw
         END IF
      #---FUN-AA0052---start-----
      WHEN "ASE"
         IF g_rebuild = "Y" THEN 
            CONNECT TO l_virtual_sch
            CALL p_create_schema_rebuild_view()
         ELSE
            CONNECT TO l_virtual_sch USER g_ase_user USING g_ase_psw
         END IF
      #---FUN-AA0052---end-------
   END CASE

   #---FUN-AA0052---start-----
   #因為Sybase無法在create view時像MSV直接SELECT @@SPID加入語法(因為不支援在語法中加入global變數)
   #所以先create function 代替,直接由function回傳@@SPID
   IF g_db_type = "ASE" THEN
      LET l_cmd = "CREATE FUNCTION spid_fun(@p_a int) returns smallint as return (SELECT @@SPID)"
      TRY
         CALL l_ch.writeLine(l_cmd)
         EXECUTE IMMEDIATE l_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY  
   END IF
   #---FUN-AA0052---end-------
   
   FOR l_v=1 TO g_view_arr.getLength() 
      LET l_table_name = g_view_arr[l_v] CLIPPED
      #LET l_plant_field = l_table_name.subString(1, l_table_name.getIndexOf('_', 1)-1),"plant"      #FUN-AB0017
      LET l_plant_field = l_table_name.subString(1, l_table_name.getIndexOf('_file', 1)-1),"plant"   #FUN-AB0017

      CASE g_db_type #FUN-A70028
         WHEN "ORA"
            LET l_cmd = "CREATE VIEW ",l_table_name, " as ",
                        "SELECT * FROM ",s_dbstring(l_real_sch CLIPPED),l_table_name,
                        #Begin:FUN-A50080
                        #" WHERE ",l_plant_field," IN (SELECT azwa03 FROM azwa_file",
                        #                             " WHERE azwa01=(SELECT sid04 FROM sid_file",
                        #                                            #" WHERE sid01=(SELECT audsid FROM V$SESSION",
                        #                                            #              " WHERE audsid=USERENV('SESSIONID')))",
                        #                                            " WHERE sid01=(SELECT userenv('SESSIONID') FROM dual))", #FUN-A40004
                        #                               " AND azwa02=(SELECT sid02 FROM sid_file",
                        #                                            #" WHERE sid01=(SELECT audsid FROM V$SESSION",
                        #                                            #              " WHERE audsid=USERENV('SESSIONID'))))"
                        #                                            " WHERE sid01=(SELECT userenv('SESSIONID') FROM dual)))" #FUN-A40004
                        " WHERE ",l_plant_field," = (SELECT sid02 FROM sid_file",
                                                    " WHERE sid01=(SELECT userenv('SESSIONID') FROM dual))"
                        #End:FUN-A50080
             #FUN-A70029 start                        
             TRY
                CALL l_ch.writeLine(l_cmd)
                EXECUTE IMMEDIATE l_cmd
             CATCH
                LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
                CALL l_ch.writeLine(l_msg)
             END TRY                        
         WHEN "MSV"
            #由 p_create_schema_msv 取代此語法
            #LET l_cmd = "CREATE VIEW ",l_table_name, " as ",
            #            "SELECT * FROM ",s_dbstring(l_real_sch CLIPPED),l_table_name,
            #            " WHERE ",l_plant_field," = (SELECT sid02 FROM sid_file",
            #                                        " WHERE sid01=(SELECT @@SPID))"
            LET l_msv_path = "fglrun %top%/azz/42mm/azz_p_create_schema_msv ",l_virtual_sch," " ,l_table_name," ",l_real_sch," ",l_plant_field
            CALL run_msv_sql(l_msv_path) RETURNING l_msg
            IF NOT cl_null(l_msg) THEN 
               CALL l_ch.writeLine(l_msg)             
            END IF 
         #FUN-A70029 end
         #---FUN-AA0052---start-----
         WHEN "ASE"
            LET l_cmd = "CREATE VIEW ",l_table_name, " as ",
                        "SELECT * FROM ",s_dbstring(l_real_sch CLIPPED),l_table_name,
                        " WHERE ",l_plant_field," = (SELECT sid02 FROM sid_file",
                                                    " WHERE sid01=(SELECT dbo.spid_fun(1)))"
             TRY
                CALL l_ch.writeLine(l_cmd)
                EXECUTE IMMEDIATE l_cmd
             CATCH
                LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
                CALL l_ch.writeLine(l_msg)
             END TRY   
         #---FUN-AA0052---end-------      
      END CASE
   END FOR

   CALL l_ch.close()

   DISCONNECT CURRENT

   LET l_msg = g_azp03_1,":create views finish"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
   #End:建立View
   
   DATABASE g_dbs
END FUNCTION

#設定實體Schema synonym to法人Schema.
PRIVATE FUNCTION p_create_schema_syn_to_legal()
   DEFINE l_legal_db STRING,
          l_source STRING,
          l_psw STRING
   DEFINE l_file STRING,
          l_path STRING,
          l_ch base.Channel
   DEFINE l_table_sql STRING,
          l_table_arr DYNAMIC ARRAY OF LIKE azw_file.azw05,
          l_table STRING,
          l_j INTEGER
   DEFINE l_cmd STRING,
          l_cnt SMALLINT
   DEFINE l_msg STRING
   DEFINE l_sql  STRING,
          l_sql2 STRING
   LET l_legal_db = g_list[g_idx].legal_db CLIPPED

   LET l_msg = g_azp03_1,":synonym to ",l_legal_db
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   LET l_file = g_today_str,"_",g_azp03_1,"_syn_legal.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_path, "w")
   CALL l_ch.writeLine(l_path)

   CALL p_create_schema_log_list(l_file)

   #取得FGLPROFILE內的設定.
   #LET l_source = "dbi.database.",g_azp03_1,".source"
   #LET l_source = FGL_GETRESOURCE(l_source)
   LET l_source = FGL_GETRESOURCE("dbi.database.ds.source") #FUN-A30088
   LET l_psw = p_create_schema_psw_decrypt(tm.ed4)

   CLOSE DATABASE
   
   LET l_msg = "CONNECT TO ",g_azp03_1
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         CONNECT TO l_source USER g_azp03_1 USING l_psw
      WHEN "MSV"
         #CONNECT TO g_azp03_1 USER g_msv_user USING g_msv_psw
         CONNECT TO "ds" USER g_msv_user USING g_msv_psw
         LET l_sql  = "SELECT COUNT(*) FROM ",g_msv_db ,".sys.tables WHERE name=LOWER(?)"
         LET l_sql2 = "SELECT COUNT(*) FROM ",g_msv_db ,".sys.synonyms WHERE synonym_name=LOWER(?)"
      #---FUN-AA0052---start-----
      WHEN "ASE"
         CONNECT TO g_azp03_1 USER g_ase_user USING g_ase_psw
      #---FUN-AA0052---end-------
   END CASE

   #取得財務模組的Table清單.
   #Begin:FUN-A50080
   #LET l_table_sql = "SELECT gat01 FROM gat_file",
   #                  " INNER JOIN zta_file ON zta01=gat01 AND zta02='ds' AND zta07='T'",
   #                  #" WHERE gat02='",g_lang,"' AND gat06 IN ('AOO','AAP','AXR','AFA','ANM','AGL')", #FUN-A50080
   #                  " WHERE gat02='",g_lang,"' AND gat06 IN (",cl_get_finance_in(),")", #FUN-A50080
   #                  " ORDER BY 1" 
   LET l_table_sql = "SELECT zta01 FROM zta_file", 
                     " WHERE zta02='ds' AND zta03 IN (",cl_get_finance_in(),") AND zta07='T' AND zta09<>'Z'",
                     " ORDER BY 1" 
   #End:FUN-A50080
   DECLARE table_cs CURSOR FROM l_table_sql
   LET l_j = 1
   FOREACH table_cs INTO l_table_arr[l_j]
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF

      LET l_j = l_j + 1
   END FOREACH
   CALL l_table_arr.deleteElement(l_j)

   FOR l_j=1 TO l_table_arr.getLength() 
      LET l_table = l_table_arr[l_j]
      LET l_table = l_table.trim()
      #先判斷是否已經有存在要建立的table,然後要先drop掉.
      CASE g_db_type #FUN-A70028
         WHEN "ORA"
            SELECT COUNT(*) INTO l_cnt FROM user_tables WHERE table_name=UPPER(l_table_arr[l_j])
         WHEN "MSV"            
            DECLARE msv_tbl_cs CURSOR FROM l_sql
            OPEN msv_tbl_cs USING l_table_arr[l_j]
            FETCH msv_tbl_cs INTO l_cnt
         #---FUN-AA0052---start-----
         WHEN "ASE"
            SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE name = LOWER(l_table_arr[l_j]) AND type = 'U'
         #---FUN-AA0052---end-------
      END CASE

      IF l_cnt>0 THEN
         LET l_cmd = "DROP TABLE ",l_table
         TRY
            CALL l_ch.writeLine(l_cmd)
            LET l_cmd = create_msv_prefix(l_cmd) #切換MS-SQL資料庫
            EXECUTE IMMEDIATE l_cmd
         CATCH
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
            CALL l_ch.writeLine(l_msg)
         END TRY
      ELSE
         #再判斷是否已經有存在相同名稱的synonym,如果有就要先drop掉.
         CASE g_db_type #FUN-A70028
            WHEN "ORA"
               SELECT COUNT(*) INTO l_cnt FROM user_synonyms WHERE synonym_name=UPPER(l_table_arr[l_j])
            WHEN "MSV"               
               DECLARE msv_syn_cs CURSOR FROM l_sql2
               OPEN msv_syn_cs USING l_table_arr[l_j]
               FETCH msv_syn_cs INTO l_cnt
            #---FUN-AA0052---start-----
            #因為Sybase無Synonym物件,只有View物件,所以判斷此view是否曾經建立過
            WHEN "ASE"
               SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE name = LOWER(l_table_arr[l_j]) AND type = 'V'
            #---FUN-AA0052---end-------
         END CASE

         IF l_cnt>0 THEN
            LET l_cmd = "DROP SYNONYM ",l_table
            #---FUN-AA0052---start-----
            #因為Sybase無法Create Synonym,只有View物件,將cmd換成DROP View語法 
            IF g_db_type = "ASE" THEN
               LET l_cmd = "DROP VIEW ",l_table
            END IF
            #---FUN-AA0052---end-------
            TRY
               CALL l_ch.writeLine(l_cmd)
               LET l_cmd = create_msv_prefix(l_cmd) 
               EXECUTE IMMEDIATE l_cmd
            CATCH
               LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
               CALL l_ch.writeLine(l_msg)
            END TRY
         END IF
      END IF

      LET l_cmd = "CREATE SYNONYM ",l_table, " for ",s_dbstring(l_legal_db),l_table
      #---FUN-AA0052---start-----
      #因為Sybase無法Create Synonym,只有View物件,將cmd換成CREATE View語法 
      IF g_db_type = "ASE" THEN
         LET l_cmd = "CREATE VIEW ",l_table, " AS SELECT * FROM ",s_dbstring(l_legal_db),l_table
      END IF
      #---FUN-AA0052---end-------
      TRY
         CALL l_ch.writeLine(l_cmd)
         EXECUTE IMMEDIATE l_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
   END FOR

   CALL l_ch.close()

   DISCONNECT CURRENT
   
   LET l_msg = g_azp03_1,":synonym to ",l_legal_db," finish"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   DATABASE g_dbs
END FUNCTION

#新建實體Schema需要將select,index的權限設定給ods:要同步修改p_create_schema_rebuild_ods_view().
#FUN-A70028:MSV不需要做grant動作.
PRIVATE FUNCTION p_create_schema_grant_ods()
   DEFINE l_source STRING,
          l_psw STRING
   DEFINE l_file STRING,
          l_path STRING,
          l_ch base.Channel
   DEFINE l_sql STRING,
          l_arr DYNAMIC ARRAY OF LIKE zta_file.zta01 #ods的grant清單
   DEFINE l_i INTEGER,
          l_table STRING,
          l_cmd STRING
   DEFINE l_msg STRING
   #Begin:FUN-A40004
   #DEFINE l_cnt SMALLINT,
   #       #l_reload_flag BOOLEAN, #是否需要重新取得grant清單
   #       l_gat06_cond  STRING #gat06的條件
   #End:FUN-A40004

   LET l_msg = g_azp03_1,":grant select,index to ods"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   LET l_file = g_today_str,"_",g_azp03_1,"_grant_ods.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   LET l_ch = base.Channel.create()
   CALL l_ch.openFile(l_path, "w")
   CALL l_ch.writeLine(l_path)

   CALL p_create_schema_log_list(l_file)

   CLOSE DATABASE

   #取得FGLPROFILE內的設定.
   #LET l_source = "dbi.database.",g_azp03_1,".source"
   #LET l_source = FGL_GETRESOURCE(l_source)
   LET l_source = FGL_GETRESOURCE("dbi.database.ds.source") #FUN-A30088
   LET l_psw = p_create_schema_psw_decrypt(tm.ed4)
   LET l_msg = "CONNECT TO ",g_azp03_1
   CALL l_ch.writeLine(l_msg)
   CONNECT TO l_source USER g_azp03_1 USING l_psw

   #Begin:FUN-A50080:不需要搞這樣複雜,如果有這種設定,不會是在新建資料庫的時候出現,一定是手動透過p_zta設定.
   #IF g_azp03_1=g_list[g_idx].legal_db CLIPPED THEN
   #   #再判斷此新建實體Schema是否為Single-DB架構,因為Single-DB的法人db也有可能會synonym到另一個法人db.
   #   SELECT count(azw05) INTO l_cnt FROM azw_file WHERE azw05=tm.azp03_1
   #   IF l_cnt>1 THEN #Single-DB才有可能會有多個相同的azw05.
   #      #這裡並不需要判斷模組的關係,只需要剔除'AIN'即可:此段SQL和取得g_ods_arr的SQL(p_create_schema_ods_view_list())一模一樣,差異在於資料庫的對象不同.
   #      LET l_reload_flag = TRUE
   #      LET l_gat06_cond = "gat06<>'AIN'"
   #   ELSE
   #      #Multi-DB的新Schema本身就是法人db,則清單應該要和g_ods_arr一樣.
   #      FOR l_i=1 TO g_ods_arr.getLength()
   #         LET l_arr[l_i] = g_ods_arr[l_i]
   #      END FOR
   #   END IF
   #ELSE
   #   #取得grant到ods的Table清單:剔除財務模組的Table(財務db)以及AIN模組,並且不是synonym的就是了.(有可能參考Schema本身也有synonym到別的Schema)
   #   LET l_reload_flag = TRUE
   #   #LET l_gat06_cond = "gat06 NOT IN ('AIN','AOO','AAP','AXR','AFA','ANM','AGL')"
   #   LET l_gat06_cond = "gat06 NOT IN (",cl_get_view_not_in(),")" #FUN-A50080:其實就和NOT VIEW的模組清單相同.
   #END IF

   #IF l_reload_flag THEN
   #   LET l_sql = "SELECT gat01 FROM gat_file",
   #               " INNER JOIN zta_file ON zta01=gat01 AND zta02='ds' AND zta07='T'",
   #               " WHERE gat02='",g_lang,"' AND ",l_gat06_cond,
   #               "   AND NOT EXISTS (SELECT synonym_name FROM user_synonyms WHERE synonym_name=UPPER(gat01))", #雖然上面已經有剔除zta07非'T'的資料,但因為取得對象是'ds',所以還是得排除新Schema的Synonym狀況.
   #               " ORDER BY 1" 
   #   DECLARE ods_cs CURSOR FROM l_sql
   #   LET l_i = 1
   #   FOREACH ods_cs INTO l_arr[l_i]
   #      IF SQLCA.SQLCODE THEN
   #         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
   #         EXIT FOREACH
   #      END IF
   #   
   #      LET l_i = l_i + 1
   #   END FOREACH
   #   CALL l_arr.deleteElement(l_i)
   #END IF

   IF g_azp03_1=g_list[g_idx].legal_db CLIPPED THEN
      #Multi-DB的新Schema本身就是法人db,則清單應該要和g_ods_arr一樣.
      FOR l_i=1 TO g_ods_arr.getLength()
         LET l_arr[l_i] = g_ods_arr[l_i]
      END FOR
   ELSE
      #LET l_sql = "SELECT gat01 FROM gat_file",
      #            " INNER JOIN zta_file ON zta01=gat01 AND zta02='ds' AND zta07='T'",
      #            " WHERE gat02='",g_lang,"' AND gat06 NOT IN (",cl_get_view_not_in(),")",
      #            "   AND NOT EXISTS (SELECT synonym_name FROM user_synonyms WHERE synonym_name=UPPER(gat01))", #雖然上面已經有剔除zta07非'T'的資料,但因為取得對象是'ds',所以還是得排除新Schema的Synonym狀況.
      #            " ORDER BY 1" 
      #非法人DB的Table清單:1.扣除財務模組的Table 2.扣除Synonym for ds的Table
      LET l_sql = "SELECT zta01 FROM zta_file", #zta09='Z'表示Synonym for ds.
                  " WHERE zta02='ds' AND zta03 NOT IN (",cl_get_finance_in(),") AND zta07='T' AND zta09<>'Z'", #AIN不剔除,這樣清單才會比較清楚與正確.
                  " ORDER BY 1" 
      DECLARE ods_cs CURSOR FROM l_sql
      LET l_i = 1
      FOREACH ods_cs INTO l_arr[l_i]
         IF SQLCA.SQLCODE THEN
            CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
            EXIT FOREACH
         END IF
      
         LET l_i = l_i + 1
      END FOREACH
      CALL l_arr.deleteElement(l_i)
   END IF
   #End:FUN-A50080
   
   FOR l_i=1 TO l_arr.getLength()
      LET l_table = l_arr[l_i]
      LET l_table = l_table.trim()
      LET l_cmd = "GRANT SELECT,INDEX ON ",l_table," TO ods"
      TRY
         CALL l_ch.writeLine(l_cmd)
         EXECUTE IMMEDIATE l_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
   END FOR

   CALL l_ch.close()

   DISCONNECT CURRENT

   LET l_msg = g_azp03_1,":grant select,index to ods finish"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   DATABASE g_dbs
END FUNCTION

#將記錄檔寫入陣列內
PRIVATE FUNCTION p_create_schema_set_log()
   DEFINE l_idx SMALLINT
   DEFINE l_log_file_arr ARRAY[9] OF STRING,
          l_i SMALLINT,
          l_log_file STRING,
          l_log_path STRING,                                       
          l_log_ch base.Channel,
          l_log STRING,
          l_str_buf base.StringBuffer

   LET l_idx = g_log_arr.getLength() + 1
   WHILE (l_idx<g_idx) #這是為了跳索引
　　　LET g_log_arr[l_idx].te1 = NULL
　　　LET g_log_arr[l_idx].te2 = NULL
　　　LET g_log_arr[l_idx].te3 = NULL
　　　LET g_log_arr[l_idx].te4 = NULL
　　　LET g_log_arr[l_idx].te5 = NULL
　　　LET g_log_arr[l_idx].te6 = NULL
　　　LET g_log_arr[l_idx].te7 = NULL
　　　LET g_log_arr[l_idx].te8 = NULL
　　　LET g_log_arr[l_idx].te9 = NULL
      LET l_idx = l_idx + 1
   END WHILE

   LET l_log_file_arr[1] = g_today_str,"_",g_azp03_1,".log"
   LET l_log_file_arr[2] = "createsch_",g_azp03_1,".log"
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         LET l_log_file_arr[3] = "exp_",tm.azp03_2 CLIPPED,".log"
      WHEN "MSV"
         LET l_log_file_arr[3] = "exp_",tm.ed_msv_ref_sch CLIPPED,".log"
      #---FUN-AA0052---start-----
      WHEN "ASE"
         LET l_log_file_arr[3] = "exp_",tm.ed_ase_ref_sch CLIPPED,".log"
      #---FUN-AA0052---end-------
   END CASE
   LET l_log_file_arr[4] = "imp_",g_azp03_1,".log"
   LET l_log_file_arr[5] = g_today_str,"_",g_azp03_1,"_syn_legal.log"
   LET l_log_file_arr[6] = g_today_str,"_",g_azp03_1,"_load.log"
   LET l_log_file_arr[7] = g_today_str,"_",g_azp03_1,"_syn.log"
   LET l_log_file_arr[8] = g_today_str,"_",g_azp03_1,"_view.log"
   LET l_log_file_arr[9] = g_today_str,"_",g_azp03_1,"_grant_ods.log"

   FOR l_i=1 TO 9
      LET l_str_buf = base.StringBuffer.create()
      LET l_log_file = l_log_file_arr[l_i]
      LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
      IF NOT os.Path.exists(l_log_path) THEN
         CASE l_i
            WHEN 1 LET g_log_arr[g_idx].te1 = NULL
            WHEN 2 LET g_log_arr[g_idx].te2 = NULL
            WHEN 3 LET g_log_arr[g_idx].te3 = NULL
            WHEN 4 LET g_log_arr[g_idx].te4 = NULL
            WHEN 5 LET g_log_arr[g_idx].te5 = NULL
            WHEN 6 LET g_log_arr[g_idx].te6 = NULL
            WHEN 7 LET g_log_arr[g_idx].te7 = NULL
            WHEN 8 LET g_log_arr[g_idx].te8 = NULL
            WHEN 9 LET g_log_arr[g_idx].te9 = NULL
         END CASE
         CONTINUE FOR
      END IF

      LET l_log_ch = base.Channel.create()
      CALL l_log_ch.openFile(l_log_path, "r")
      
      WHILE TRUE
         LET l_log = l_log_ch.readLine()
      
         IF l_log_ch.isEof() THEN
            EXIT WHILE
         END IF
      
         LET l_log = l_log,"\n"
         CALL l_str_buf.append(l_log)
      END WHILE

      CASE l_i
         WHEN 1 LET g_log_arr[g_idx].te1 = l_str_buf.toString()
         WHEN 2 LET g_log_arr[g_idx].te2 = l_str_buf.toString()
         WHEN 3 LET g_log_arr[g_idx].te3 = l_str_buf.toString()
         WHEN 4 LET g_log_arr[g_idx].te4 = l_str_buf.toString()
         WHEN 5 LET g_log_arr[g_idx].te5 = l_str_buf.toString()
         WHEN 6 LET g_log_arr[g_idx].te6 = l_str_buf.toString()
         WHEN 7 LET g_log_arr[g_idx].te7 = l_str_buf.toString()
         WHEN 8 LET g_log_arr[g_idx].te8 = l_str_buf.toString()
         WHEN 9 LET g_log_arr[g_idx].te9 = l_str_buf.toString()
      END CASE

      CALL l_str_buf.clear()
      CALL l_log_ch.close()
   END FOR
END FUNCTION

#FUN-9C0157:找出同一天的log檔內,有多少log檔是有紀錄錯誤的.
PRIVATE FUNCTION p_create_schema_err_log_list()
   DEFINE l_dirhandle SMALLINT,
          l_child STRING,
          l_log_path STRING,
          l_today_idx SMALLINT,
          l_str_buf base.StringBuffer,
          l_err_msg STRING
   DEFINE l_i SMALLINT,
          l_log_token base.StringTokenizer,
          l_log STRING

   LET l_str_buf = base.StringBuffer.create()

   #LET l_dirhandle = os.Path.diropen(g_tmpdir)
   #WHILE l_dirhandle>0
   #   LET l_child = os.Path.dirnext(l_dirhandle)
   #   IF l_child IS NULL THEN
   #      EXIT WHILE
   #   END IF
   #   IF l_child == "." OR l_child == ".." THEN
   #      CONTINUE WHILE
   #   END IF

   #   #要將檔名有g_today_str的log檔案,且log內容有紀錄'ERROR',則要將路徑寫入g_log_ch內.
   #   LET l_log_path = os.Path.join(g_tmpdir, l_child)
   #   IF os.Path.isfile(l_log_path) THEN
   #      LET l_today_idx = l_child.getIndexOf(g_today_str, 1)
   #      IF l_today_idx>0 THEN
   #         IF p_create_schema_log_has_err(l_child) THEN
   #            LET l_err_msg = "ERROR log : ",l_log_path,"\n"
   #            CALL l_str_buf.append(l_err_msg)
   #         END IF
   #      END IF
   #   END IF
   #END WHILE

   LET l_log_token = base.StringTokenizer.create(g_log_list.toString(), ",")
   WHILE l_log_token.hasMoreTokens()
      LET l_log = l_log_token.nextToken()
      LET l_log_path = os.Path.join(g_tmpdir, l_log)
      IF p_create_schema_log_has_err(l_log) THEN
         LET l_err_msg = "ERROR log : ",l_log_path,"\n"
         CALL l_str_buf.append(l_err_msg)
      END IF
   END WHILE

   RETURN l_str_buf.toString()
END FUNCTION

#重設ods的view           
PRIVATE FUNCTION p_create_schema_create_ods_view()
   DEFINE l_i,l_j INTEGER
   DEFINE l_table STRING,
          l_sch STRING,
          l_cmd STRING
   DEFINE l_cnt SMALLINT
   DEFINE l_msg STRING

   CALL g_ods_ch.writeLine("creating ods views")
   DISPLAY "creating ods views"
   
   #取得實體Schema的清單.
     
   CALL p_create_schema_progress("Step 2(ods):get ods schema")
   
   CALL p_create_schema_ods_sch_list()

   CLOSE DATABASE
   
   CALL g_ods_ch.writeLine("DATABASE ods") 
   DATABASE ods
   
   CALL p_create_schema_progress("Step 3(ods):rebuild synonym")
   FOR l_j=1 TO g_ods_syn.getLength()  #FUN-A70115
      LET l_table = g_ods_syn[l_j]
      LET l_table = l_table.trim()
      CALL create_synonym(g_ods_syn[l_j])
   END FOR

   CALL p_create_schema_progress("Step 4(ods):create ods view")
   FOR l_j=1 TO g_ods_arr.getLength()
      LET l_table = g_ods_arr[l_j]
      LET l_table = l_table.trim() 

      
      #先判斷是否已經有存在相同名稱的view,如果有就要先drop掉.
      CASE g_db_type #FUN-A70028
         WHEN "ORA"
            SELECT COUNT(*) INTO l_cnt FROM user_views WHERE view_name=UPPER(g_ods_arr[l_j])
         WHEN "MSV"
            SELECT COUNT(*) INTO l_cnt FROM sys.views WHERE name=LOWER(g_ods_arr[l_j])
         #---FUN-AA0052---start-----
         WHEN "ASE"
            SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE name=LOWER(g_ods_arr[l_j]) AND type='V'
         #---FUN-AA0052---end-------
      END CASE

      IF l_cnt>0 THEN
         LET l_cmd = "DROP VIEW ",l_table
         TRY
            CALL g_ods_ch.writeLine(l_cmd)
            EXECUTE IMMEDIATE l_cmd
         CATCH
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
            CALL g_ods_ch.writeLine(l_msg)
         END TRY
      ELSE
         #再判斷是否已經有存在相同名稱的synonym,如果有就要先drop掉.
         CASE g_db_type #FUN-A70028
            WHEN "ORA"
               SELECT COUNT(*) INTO l_cnt FROM user_synonyms WHERE synonym_name=UPPER(g_ods_arr[l_j])
            WHEN "MSV"
               SELECT COUNT(*) INTO l_cnt FROM sys.synonyms WHERE name=LOWER(g_ods_arr[l_j])
            #---FUN-AA0052---start-----
            #因為Sybase無Synonym物件,只有View物件,上面已經做過view的處理,故底下不再做Synonym物件的dorp
            WHEN "ASE"
               LET l_cnt = 0
            #---FUN-AA0052---end-------
         END CASE

         IF l_cnt>0 THEN
            LET l_cmd = "DROP SYNONYM ",l_table
            TRY
               CALL g_ods_ch.writeLine(l_cmd)
               EXECUTE IMMEDIATE l_cmd
            CATCH
               LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
               CALL g_ods_ch.writeLine(l_msg)
            END TRY
         END IF
      END IF

      LET l_cmd = NULL
      FOR l_i=1 TO g_sch_arr.getLength()
         LET l_sch = g_sch_arr[l_i]
         LET l_sch = l_sch.trim()
         IF l_i=1 THEN 
            LET l_cmd = "CREATE VIEW ",l_table," AS ("
         ELSE
            LET l_cmd = l_cmd," UNION ALL "
         END IF

         LET l_cmd = l_cmd,"(SELECT '",l_sch,"' DBNAME,",s_dbstring(l_sch),l_table,".* FROM ",s_dbstring(l_sch),l_table,")"
      END FOR

      LET l_cmd = l_cmd,")"
      TRY
         CALL g_ods_ch.writeLine(l_cmd)
         EXECUTE IMMEDIATE l_cmd
      CATCH
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL g_ods_ch.writeLine(l_msg)
      END TRY
   END FOR

   #這樣可以避免畫面沒有重新開啟,卻繼續執行而造成比較難查到的bug.
   CALL g_ods_arr.clear()
   CALL g_sch_arr.clear()

   CALL g_ods_ch.writeLine("create ods views finish")
   DISPLAY "create ods views finish"
   CALL p_create_schema_progress("Step 5(ods):Finish")
 
   CLOSE DATABASE

   DATABASE g_dbs
END FUNCTION

#取得建立ods需要用到的已經建立且屬於ERP的資料庫.
PRIVATE FUNCTION p_create_schema_ods_sch_list()
   DEFINE l_sch_sql STRING,
          l_i INTEGER,
          l_msg STRING
   DEFINE l_msv_sch_sql STRING, #FUN-A70028
          l_msv_sch_pre STRING,
          l_msv_sch STRING,
          l_msv_sch_cnt SMALLINT,
          l_sch_arr2 DYNAMIC ARRAY OF LIKE azw_file.azw05,
          l_j INTEGER
            
   CALL g_sch_arr.clear()

   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         #FUN-A40004
         #LET l_sch_sql = "SELECT distinct azw05 FROM azw_file", #取得所有實體Schema
         #                " INNER JOIN all_users ON username=UPPER(azw05)", #判斷實體Schema是否建立 #FUN-A10073
         #                " WHERE azwacti='Y' AND azw05<>'ds' AND EXISTS (SELECT zta02 FROM zta_file WHERE zta02=azw05)", #判斷是否為ERP資料庫:一般來說,zta_file內有資料的話,就應該是ERP資料庫.
         #                " ORDER BY 1"
         LET l_sch_sql = "SELECT azwd01 FROM azwd_file",
                         " INNER JOIN all_users ON username=UPPER(azwd01)",
                         #" WHERE EXISTS (SELECT zta02 FROM zta_file WHERE zta02=azwd01)", #FUN-A40004:不特別剔除ds,也不管zta是否有資料,避免zta資料造成建立失敗.
                         " ORDER BY 1" 

         DECLARE sch1_cs CURSOR FROM l_sch_sql
         LET l_i = 1
         FOREACH sch1_cs INTO g_sch_arr[l_i]
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
               EXIT FOREACH
            END IF
         
            LET l_msg = "ods include:",g_sch_arr[l_i]
            CALL g_ods_ch.writeLine(l_msg)
            DISPLAY l_msG
         
            LET l_i = l_i + 1
         END FOREACH
         CALL g_sch_arr.deleteElement(l_i)
      WHEN "MSV"
         LET l_msv_sch_pre = FGL_GETENV("MSSQLAREA"),"_"

         LET l_sch_sql = "SELECT azwd01 FROM azwd_file",
                         " ORDER BY 1"

         DECLARE sch2_cs CURSOR FROM l_sch_sql
         LET l_i = 1
         LET l_j = 0
         FOREACH sch2_cs INTO l_sch_arr2[l_i]
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
               EXIT FOREACH
            END IF
         
            #檢查Schema是否已經建立.
            LET l_msv_sch = l_msv_sch_pre,l_sch_arr2[l_i]
            LET l_msv_sch_sql = "SELECT COUNT(*) FROM sys.databases WHERE name=LOWER('",l_msv_sch,"')"
            DECLARE msv_sch_cs SCROLL CURSOR FROM l_msv_sch_sql
            OPEN msv_sch_cs
            FETCH FIRST msv_sch_cs INTO l_msv_sch_cnt
            IF l_msv_sch_cnt>0 THEN           
               LET l_j = l_j + 1
               LET g_sch_arr[l_j] = l_sch_arr2[l_i] 
               LET l_msg = "ods include:",l_msv_sch
               CALL g_ods_ch.writeLine(l_msg)
               DISPLAY l_msg
            END IF
            CLOSE msv_sch_cs

            LET l_i = l_i + 1
         END FOREACH
      #---FUN-AA0052---start-----
      WHEN "ASE"
         LET l_sch_sql = "SELECT azwd01 FROM azwd_file",
                         " INNER JOIN master.dbo.sysdatabases ON name=LOWER(azwd01)",
                         " ORDER BY 1" 

         DECLARE ase_sch1_cs CURSOR FROM l_sch_sql
         LET l_i = 1
         FOREACH ase_sch1_cs INTO g_sch_arr[l_i]
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
               EXIT FOREACH
            END IF
         
            LET l_msg = "ods include:",g_sch_arr[l_i]
            CALL g_ods_ch.writeLine(l_msg)
            DISPLAY l_msG
         
            LET l_i = l_i + 1
         END FOREACH
         CALL g_sch_arr.deleteElement(l_i)
      #---FUN-AA0052---end-------
   END CASE
END FUNCTION

#顯現ods記錄檔:ods只有一份,所以單獨處理.
PRIVATE FUNCTION p_create_schema_set_ods_log()
   DEFINE l_file STRING,
          l_path STRING,
          l_ch base.Channel,
          l_str_buf base.StringBuffer,
          l_line STRING

   LET l_file = g_today_str,"_ods.log"
   LET l_path = os.Path.join(g_tmpdir, l_file)
   IF NOT os.Path.exists(l_path) THEN
      DISPLAY NULL TO te10
   ELSE
      LET l_str_buf = base.StringBuffer.create()
      LET l_ch = base.Channel.create()
      CALL l_ch.openFile(l_path, "r")

      WHILE TRUE
         LET l_line = l_ch.readLine()
      
         IF l_ch.isEof() THEN
            EXIT WHILE
         END IF
      
         LET l_line = l_line,"\n"
         CALL l_str_buf.append(l_line)
      END WHILE

      DISPLAY l_str_buf.toString() TO te10
      
      CALL l_str_buf.clear()
      CALL l_ch.close()
   END IF
END FUNCTION

#顯現結束的訊息畫面
PRIVATE FUNCTION p_create_schema_end_info(p_msg_code, p_msg_parm)
   DEFINE p_msg_code,p_msg_parm STRING
   DEFINE l_comment STRING       

   LET l_comment = p_create_schema_err_log_list(),cl_getmsg_parm(p_msg_code, g_lang, p_msg_parm) #FUN-9C0157
   CALL g_log_ch.writeLine("")           #FUN-B70083
   CALL g_log_ch.writeLine(l_comment)    #FUN-B70083  當客戶家發生問題時,都不曉得要回饋那個log檔,因此特別也將此訊息記錄在log檔中
   MENU "Information Dialog" ATTRIBUTES (STYLE="dialog", COMMENT=l_comment)
      ON ACTION accept
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU
END FUNCTION

#顯現訊息畫面
FUNCTION p_create_schema_info(p_msg_code, p_msg_parm)
   DEFINE p_msg_code,p_msg_parm STRING

   MENU "Information Dialog" ATTRIBUTES (STYLE="dialog", COMMENT=cl_getmsg_parm(p_msg_code, g_lang, p_msg_parm))
      ON ACTION accept
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU
END FUNCTION

#重新建立ods的View:for aooi931.
#此FUNCTION為了出貨時要重新建立ods的View而建立.
FUNCTION p_create_schema_rebuild_ods_view()
   DEFINE l_log_file,l_log_path STRING
   DEFINE l_i,l_j INTEGER,
          l_sch LIKE azw_file.azw05,
          l_table STRING
   DEFINE l_file STRING,
          l_path STRING,
          l_ch base.Channel,
          l_cmd STRING,
          l_msg STRING
   DEFINE l_sql STRING,
          l_arr DYNAMIC ARRAY OF LIKE zta_file.zta01

   #這FUNCTION是從aooi931直接呼叫,因此需要自己重新設定記錄檔的路徑.          
   LET g_tmpdir = os.Path.join(FGL_GETENV("TOP"), "tmp")

   IF NOT os.Path.exists(g_tmpdir) THEN #預設一定會有這個資料夾
      IF NOT os.Path.mkdir(g_tmpdir) THEN
         DISPLAY "Create folder ",g_tmpdir," fails."
         RETURN
      END IF
   END IF

   #LET g_pid = FGL_GETPID()
   #LET g_pid = g_today_str.trim()
   LET g_today_str = TODAY USING "yymmdd" #FUN-9C0157
   LET g_db_type = cl_db_get_database_type() #FUN-A70028

   LET l_log_file = g_today_str,"_rebuild_ods.log"
   LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
   DISPLAY "ods rebuild log:",l_log_path
   LET g_log_ch = base.Channel.create()
   CALL g_log_ch.openFile(l_log_path, "w")
   CALL g_log_ch.writeLine(l_log_path)
         
   LET l_log_file = g_today_str,"_ods.log"
   LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
   LET l_msg = "ods detail log:",l_log_path
   CALL g_log_ch.writeLine(l_msg)
   LET g_ods_ch = base.Channel.create()
   CALL g_ods_ch.openFile(l_log_path, "w")
   CALL g_ods_ch.writeLine(l_log_path) 
   
   CALL cl_progress_bar(5)
   CALL cl_progressing("Step 1(ods):ods view list")
   
   CALL p_create_schema_ods_view_list() #g_log_ch
   
   #這段在create_ods_view裡面也會做一次,原本grant流程是在建立Schema時,順便處理,但現在是全部Schema一起做,所以才得先撈.
   CALL p_create_schema_ods_sch_list() #g_ods_ch

   IF g_db_type="ORA" THEN #FUN-A70028
      #有問題的話,要同步修改p_create_schema_grant_ods().
      #不能和原本的p_create_schema_grant_ods()共用的原因在於還得判斷實體Schema是否是剛剛建立的,這樣會增加原本FUNCTION的負擔.
      CLOSE DATABASE
      
      FOR l_j=1 TO g_sch_arr.getLength()
         LET l_sch = g_sch_arr[l_j] CLIPPED
         DATABASE l_sch
         
         CALL l_arr.clear()
      
         #這裡就不分是否為法人db了,因為Single-DB的法人db也有可能會synonym到另一個法人db.
         #取得grant到ods的Table清單:剔除那六個財務模組的Table(財務db)以及AIN模組,並且不是synonym的就是了.(有可能參考Schema本身也有synonym到別的Schema)
         #和p_create_schema_grant_ods()差異:
         #1.在zta02的條件,因為p_create_schema_grant_ods()的時機點是新建Schema,所以沒有zta的資料,但是這邊是已經存在zta的資料,所以得這樣做才正確.
         #2.實際上並不需要在判斷gat06的條件,因為zta裡面的資料已經是正確了.
         #3.因為zta裡面的資料已經是正確了,所以不需要再判斷Synonym了.
         #Begin:FUN-A50080
         #LET l_sql = "SELECT gat01 FROM gat_file",
         #            " INNER JOIN zta_file ON zta01=gat01 AND zta02='",l_sch,"' AND zta07='T'",
         #            " WHERE gat02='",g_lang,"' AND gat06<>'AIN'",
         #            " ORDER BY 1"
         #不能加上zta09<>'Z'的條件,因為有可能zta02會是ds,則會因為zta09而導致其他DB synonym到ds的Table沒有做到GRANT的動作.
         LET l_sql = "SELECT zta01 FROM zta_file",
                     " WHERE zta02='",l_sch,"' AND zta07='T'", #AIN不剔除,這樣清單才會比較清楚與正確.
                     " ORDER BY 1" 
         #End:FUN-A50080
         DECLARE ods_cs2 CURSOR FROM l_sql
         LET l_i = 1
         FOREACH ods_cs2 INTO l_arr[l_i]
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
               EXIT FOREACH
            END IF
         
            LET l_i = l_i + 1
         END FOREACH
         CALL l_arr.deleteElement(l_i)
      
         LET l_file = g_today_str,"_",l_sch,"_grant_ods.log"
         LET l_path = os.Path.join(g_tmpdir, l_file)
         LET l_msg = l_sch," grant log path:",l_path
         CALL g_log_ch.writeLine(l_msg)
         DISPLAY l_msg
         LET l_ch = base.Channel.create()
         CALL l_ch.openFile(l_path, "w")
         CALL l_ch.writeLine(l_path)
      
         FOR l_i=1 TO l_arr.getLength()
            LET l_table = l_arr[l_i]
            LET l_table = l_table.trim()
            LET l_cmd = "GRANT SELECT,INDEX ON ",l_table," TO ods" 
            TRY
               CALL l_ch.writeLine(l_cmd)
               EXECUTE IMMEDIATE l_cmd
            CATCH
               LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
               CALL l_ch.writeLine(l_msg)
            END TRY
         END FOR
         
         CALL l_ch.close()
         
         CLOSE DATABASE
      END FOR
      
      DATABASE g_dbs
   END IF

   #---FUN-BB0118---增加create synonym--start-----
   FOR l_j=1 TO g_ods_syn.getLength()
      LET l_table = g_ods_syn[l_j]
      LET l_table = l_table.trim()
      CALL create_synonym(g_ods_syn[l_j])
   END FOR
   #---FUN-BB0118----------------------end-------
   
   CALL p_create_schema_create_ods_view() #g_ods_ch
   
   CALL g_log_ch.close()
   CALL g_ods_ch.close()

   CALL cl_ins_del_sid(1, g_plant) #原因同MAIN後面的說明

   RETURN l_log_path
END FUNCTION

#檢查INDEX是否已經建立。如果已經建立，則會先DROP掉再重新建立。
FUNCTION create_view_index(tab_name, field_name, l_ch)     #No.FUN-A20015
   DEFINE l_ch                 base.Channel
   DEFINE field_name,tab_name  STRING
   DEFINE l_exist              INTEGER
   DEFINE idx_name,idx_name_t  STRING
   DEFINE l_msg, l_sql         STRING
   DEFINE l_real_sch           STRING
   
   LET idx_name = field_name,"_idx"
   LET idx_name_t = UPSHIFT(idx_name) 
   
   CASE g_db_type #FUN-A70028
      WHEN "ORA"
         LET l_sql = "SELECT COUNT(*) FROM all_indexes WHERE index_name = '" || idx_name_t || "'"
      WHEN "MSV"
         LET l_sql = "SELECT COUNT(*) FROM ",g_real_msvdb,".sys.indexes WHERE name = '" || idx_name || "'"
      #---FUN-AA0052---start-----
      WHEN "ASE"
         LET l_sql = "SELECT COUNT(*) FROM sysindexes WHERE name = '" || idx_name || "'"
      #---FUN-AA0052---end-------
   END CASE
   
   PREPARE idx_pre1 FROM l_sql
   EXECUTE idx_pre1 INTO l_exist

   IF l_exist = 0 THEN      #INDEX不存在，就建立。已存在就忽略。 
      TRY
         LET l_sql = "CREATE INDEX ", idx_name, " ON ", tab_name, "(", field_name, ")"
         CALL l_ch.writeLine(l_sql)
         IF g_db_type = "MSV" THEN
            LET l_sql = "use ",g_real_msvdb ,";",l_sql
         END IF
         EXECUTE IMMEDIATE l_sql
      CATCH
         LET l_msg = "ERROR:SQLCODE=" || SQLCA.SQLCODE || ",SQLERRD[2]=" || SQLCA.SQLERRD[2]
         CALL l_ch.writeLine(l_msg)
      END TRY
   END IF
END FUNCTION
     
#FUN-A70029 start
PRIVATE FUNCTION create_msv_prefix(p_cmd)
   DEFINE p_cmd  STRING 
   
   IF g_db_type = "MSV" THEN
      LET p_cmd = "use ",g_msv_db ,";" , p_cmd
   END IF   
   RETURN p_cmd
END FUNCTION 

PRIVATE FUNCTION run_msv_sql(p_cmd)
   DEFINE p_cmd       STRING   
   DEFINE l_cmd       STRING
   DEFINE l_str       STRING
   DEFINE l_line      STRING
   DEFINE l_temp      STRING
   DEFINE l_i         SMALLINT
   DEFINE lc_channel  base.channel
   DEFINE l_channel   base.channel
   
   LET l_channel = base.Channel.create()
   CALL l_channel.openpipe( p_cmd,"r")
   CALL l_channel.setDelimiter("")
   
   LET l_i = 1 
   LET l_str = ""
   WHILE l_channel.read(l_temp)
      LET l_str = l_str , l_temp ,"\n"
   END WHILE
   CALL l_channel.close()
   
   RETURN l_str
END FUNCTION 
#FUN-A70029 end

#FUN-A70115 start
PRIVATE FUNCTION create_synonym(l_table)
DEFINE l_table LIKE zta_file.zta01
DEFINE l_cnt   INTEGER
DEFINE l_cmd   STRING,
       l_msg   STRING

      CASE g_db_type
         WHEN "ORA"
            SELECT COUNT(*) INTO l_cnt FROM user_synonyms WHERE synonym_name=upper(l_table)
         WHEN "MSV"
            SELECT COUNT(*) INTO l_cnt FROM sys.synonyms WHERE name=l_table
         #---FUN-AA0052---start-----
         WHEN "ASE"
            SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE name=l_table AND type='V'
         #---FUN-AA0052---end-------
      END CASE

      IF l_cnt=0 THEN
         #---FUN-AA0052---start-----
         #因為Sybase無法Create Synonym,只有View物件,改寫此處CREATE SYNONYM語法
         #LET l_cmd = "CREATE SYNONYM ",l_table, " for ",s_dbstring("ds"),l_table
         CASE 
            WHEN (g_db_type = "ORA" OR g_db_type = "MSV")
               LET l_cmd = "CREATE SYNONYM ",l_table, " for ",s_dbstring("ds"),l_table
            WHEN (g_db_type = "ASE")
               LET l_cmd = "CREATE VIEW ",l_table, " AS SELECT * FROM ",s_dbstring("ds"),l_table
         END CASE
         #---FUN-AA0052---end-------
         TRY
            CALL g_ods_ch.writeLine(l_cmd)
            EXECUTE IMMEDIATE l_cmd
         CATCH
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
            CALL g_ods_ch.writeLine(l_msg)
         END TRY
      END IF
END FUNCTION

FUNCTION p_create_schema_rebuild_syn_view(l_azw06) 
   DEFINE p_db           STRING,
          l_log_file     STRING,
          l_log_path     STRING,
          l_azw05     LIKE azw_file.azw05,
          l_azw06     LIKE azw_file.azw06
   
   LET g_db_type = cl_db_get_database_type()
   
   LET g_azp03_1 = l_azw06
   LET g_tmpdir = os.Path.join(FGL_GETENV("TOP"), "tmp")
   LET g_today_str = TODAY USING "yymmdd"
   LET g_msv_db = FGL_GETENV("MSSQLAREA"),"_" ,g_azp03_1
            
   LET l_log_file = g_today_str,"_",g_azp03_1,".log"
   LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
   LET g_log_ch = base.Channel.create()
   CALL g_log_ch.openFile(l_log_path, "w") #因為牽涉很多FUNCTION,所以改成global變數.
   CALL g_log_ch.writeLine(l_log_path)
   LET g_log_list = base.StringBuffer.create()
   
   CALL cl_progress_bar(3)  #三個流程
   CALL p_create_schema_progress("Step 1(%1):Start to rebuild")
   
   SELECT DISTINCT azw05 INTO l_azw05 FROM azw_file WHERE azw06 = l_azw06
   LET g_real_db = l_azw05

   CALL p_create_schema_syn_view_list()
   
   LET g_rebuild = "Y"
   
   CALL p_create_schema_virtual_syn_view()
   CALL p_create_schema_progress("Step 3(%1):Finish rebuild")
   
END FUNCTION

FUNCTION p_create_schema_progress(msg)
   DEFINE msg   STRING

   LET msg = SFMT(msg , g_azp03_1 ) #將資料庫名稱附加到訊息中
   CALL cl_progressing(msg)

END FUNCTION

FUNCTION p_create_schema_rebuild_view()
   DEFINE l_v,l_cnt     INTEGER 
   DEFINE l_cmd         STRING,
          l_msg         STRING,
          l_table_name  STRING,
          l_plant_field STRING,
          l_real_sch    STRING,
          l_virtual_sch STRING,
          l_msv_path    STRING,
          l_grant_cmd   STRING,
          l_sql         STRING
        
  
   #FUN-A80140
   IF g_db_type="MSV" THEN
      LET l_sql = "SELECT COUNT(*) FROM ",g_msv_db,".sys.views WHERE name= ?"
      PREPARE view_pre1 FROM l_sql
   END IF

   FOR l_v=1 TO g_view_arr.getLength() 
      LET l_table_name = g_view_arr[l_v] CLIPPED

      #先判斷是否已經有存在相同名稱的view,如果有就要先drop掉.
      CASE g_db_type #FUN-A70028
         WHEN "ORA"
            SELECT COUNT(*) INTO l_cnt FROM user_views WHERE view_name=UPPER(g_view_arr[l_v])
         WHEN "MSV"
            EXECUTE view_pre1 USING g_view_arr[l_v] INTO l_cnt
         #---FUN-AA0052---start-----
         WHEN "ASE"
            SELECT COUNT(*) INTO l_cnt FROM sysobjects WHERE name=LOWER(g_view_arr[l_v]) AND type='V'
         #---FUN-AA0052---end-------
      END CASE

      IF l_cnt>0 THEN
         LET l_cmd = "DROP VIEW ",l_table_name
         TRY            
            EXECUTE IMMEDIATE l_cmd
         CATCH
            LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]            
         END TRY
      END IF 
         
   END FOR
END FUNCTION  
#FUN-A70115 end

#---FUN-B70083---start-----
#[
# Descriptions...: 新建實體DB時將系統中相關營運中心代碼欄位Update成新的營運中心代碼(azw01)
# Date & Author..: 2011/07/21 by Jay
# Input Parameter: none
# Return Code....: 
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_create_schema_default_value()
   DEFINE l_msg      STRING
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_length   LIKE type_file.num5 
   DEFINE l_upd_sql  STRING
   DEFINE l_azw01    LIKE azw_file.azw01
   DEFINE l_azw05    LIKE azw_file.azw05
   DEFINE l_update_target DYNAMIC ARRAY OF RECORD   #記錄需update的資料表和欄位名稱
              table_name LIKE sch_file.sch01,                                
              field_name LIKE sch_file.sch02,
              pk_name    STRING                     #記錄此table pk欄位,若有二個欄位以上用|隔開,如"aaa00|aaa01|aaa02"
              END RECORD
   DEFINE l_gao05    LIKE gao_file.gao05            #FUN-BB0118

   #將這個部份的log資料直接紀錄在today_xxx.log中,例如100119_ds99.log
   CALL g_log_ch.writeLine("")
   CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")   
   LET l_msg = g_azp03_1,":update default vaule(azw01) data"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg

   CALL l_update_target.clear()
   
   LET l_update_target[1].table_name = "oaz_file"
   LET l_update_target[1].field_name = "oaz02p"
   LET l_update_target[1].pk_name = "oaz00"
   
   LET l_update_target[2].table_name = "ooz_file"
   LET l_update_target[2].field_name = "ooz02p"
   LET l_update_target[2].pk_name = "ooz00"
   
   LET l_update_target[3].table_name = "apz_file"
   LET l_update_target[3].field_name = "apz02p"
   LET l_update_target[3].pk_name = "apz00"
   
   LET l_update_target[4].table_name = "apz_file"
   LET l_update_target[4].field_name = "apz04p"
   LET l_update_target[4].pk_name = "apz00"
   
   LET l_update_target[5].table_name = "nmz_file"
   LET l_update_target[5].field_name = "nmz02p"
   LET l_update_target[5].pk_name = "nmz00"
   
   LET l_update_target[6].table_name = "imd_file"   #FUN-B90135因為取消apy模組,將cpa_file改成imd_file
   LET l_update_target[6].field_name = "imd20"      #FUN-B90135因為取消apy模組,將cpa150改成imd20
   LET l_update_target[6].pk_name = "imd01"         #FUN-B90135因為取消apy模組,將cpa00改成imd01
   
   LET l_update_target[7].table_name = "sma_file"
   LET l_update_target[7].field_name = "sma87"
   LET l_update_target[7].pk_name = "sma00"
   
   LET l_update_target[8].table_name = "faa_file"
   LET l_update_target[8].field_name = "faa02p"
   LET l_update_target[8].pk_name = "faa00"
   
   LET l_update_target[9].table_name = "ccz_file"
   LET l_update_target[9].field_name = "ccz11"
   LET l_update_target[9].pk_name = "ccz00"

   #---FUN-B90135---start-----
   LET l_update_target[10].table_name = "apg_file"
   LET l_update_target[10].field_name = "apg03"
   LET l_update_target[10].pk_name = "apg01|apg02"

   LET l_update_target[11].table_name = "oma_file"
   LET l_update_target[11].field_name = "oma66"
   LET l_update_target[11].pk_name = "oma01"

   LET l_update_target[12].table_name = "apa_file"
   LET l_update_target[12].field_name = "apa100"
   LET l_update_target[12].pk_name = "apa01"
   #---FUN-B90135---end-------
   
   #MOD-C40010 add start -----
   LET l_update_target[13].table_name = "omb_file"
   LET l_update_target[13].field_name = "omb44"
   LET l_update_target[13].pk_name = "omb01|omb03"
   #MOD-C40010 add end -----

   #準備做欄位的Update
   LET l_length = l_update_target.getLength()
   LET l_azw05 = g_azp03_1

   #找出新schema的營運中心代碼
   SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw05 = azw06 AND azw05 = l_azw05 
   IF SQLCA.SQLCODE THEN
      LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
      CALL g_log_ch.writeLine(l_msg)
      LET l_msg = g_azp03_1,":update default vaule(azw01) is failed."
   ELSE   
      FOR l_i = 1 TO l_length
          LET l_upd_sql = "UPDATE ", s_dbstring(g_azp03_1), l_update_target[l_i].table_name,
                          " SET ", l_update_target[l_i].field_name, " = '", l_azw01 CLIPPED, "'"

          #執行UPDATE程序
          TRY
             #---FUN-BB0118---start-----
             IF g_azp03_1 <> g_list[g_idx].legal_db CLIPPED THEN
                CALL g_log_ch.writeLine("")
                CALL g_log_ch.writeLine("SELECT gao05 FROM gao_file WHERE zta01 = " || l_update_target[l_i].table_name)
                SELECT gao05 INTO l_gao05 FROM gao_file
                  WHERE gao01 = 
                    (SELECT zta03 FROM zta_file 
                       WHERE zta02 = 'ds' AND zta01 = l_update_target[l_i].table_name)
                CALL g_log_ch.writeLine("SELECT OK")
                IF l_gao05 = "Y" THEN
                   CONTINUE FOR
                END IF
             END IF
             #---FUN-BB0118---end-------
             
             CALL g_log_ch.writeLine(l_upd_sql)
             EXECUTE IMMEDIATE l_upd_sql
             CALL g_log_ch.writeLine("UPDATE OK")
          CATCH
             LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
             CALL g_log_ch.writeLine(l_msg)
          END TRY  
      END FOR
      LET l_msg = g_azp03_1,":update default vaule(azw01) finish."
   END IF
   
   CALL g_log_ch.writeLine(l_msg)
   CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")   
   CALL g_log_ch.writeLine("")
   DISPLAY l_msg

   CALL p_create_schema_update_value()
END FUNCTION  
#---FUN-B70083---end-------

#---FUN-B90135---start-----
#[
# Descriptions...: 提供使用者輸入要Update的營運中心名稱的畫面
# Date & Author..: 2011/09/29 by Jay
# Input Parameter: none
# Return Code....: 
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_create_schema_tbPlant_b()
   DEFINE l_sql          STRING
   DEFINE l_flag         LIKE type_file.chr1   #判斷必要欄位是否有輸入
   DEFINE l_rec_b        LIKE type_file.num5
   DEFINE l_ac           LIKE type_file.num5
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_i            LIKE type_file.num5

   IF NOT p_create_schema_tbPlant_fill() THEN
      RETURN FALSE
   END IF

   #有要建立的schema,但不需設定新/舊營運中心的對應關係,此種情況就是要建立虛擬DB
   #所以不進入下面的設定畫面
   IF (NOT cl_null(g_build_schema)) AND g_plant_list.getLength() = 0 THEN
      RETURN TRUE
   END IF

   #提醒使用者需輸入新/舊營運中心的對應關係
   CALL p_create_schema_info("azz1195", NULL) 
   
   LET l_rec_b = g_plant_list.getLength()
   LET l_sql = "SELECT COUNT(*) FROM azw_file ", 
               "  WHERE azw05 = ? AND azw01 = ? "
   PREPARE tbPlant_b_azw01_pre FROM l_sql
   
   OPEN WINDOW p_plant_list_w AT 4, 16
        WITH FORM "azz/42f/p_plant_list" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("p_plant_list")
 
   MESSAGE ''

   INPUT ARRAY g_plant_list WITHOUT DEFAULTS FROM s_plant.*
         ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=l_rec_b,UNBUFFERED,
                    INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
      BEFORE INPUT
         IF l_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_required("azw01_new", TRUE)
         CALL cl_set_comp_entry("azw02_old,azw01_old,azw05_old,azw02_new,azw05_new", FALSE)
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION controlp INFIELD azw01_new
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_azw15"
         LET g_qryparam.default1 = g_plant_list[l_ac].azw01_new
         LET g_qryparam.arg1     = g_plant_list[l_ac].azw05_new
         CALL cl_create_qry() RETURNING g_plant_list[l_ac].azw01_new
         DISPLAY g_plant_list[l_ac].azw01_new TO azw01_new
         NEXT FIELD azw01_new

      AFTER FIELD azw01_new
         #檢查所輸入營運中心,是不是屬於此筆要建立schema的營運中心名稱
         IF NOT cl_null(g_plant_list[l_ac].azw01_new) THEN
            EXECUTE tbPlant_b_azw01_pre 
              USING g_plant_list[l_ac].azw05_new ,g_plant_list[l_ac].azw01_new 
              INTO l_cnt
              
            IF l_cnt = 0 THEN
               CALL cl_err_msg("", "azz1196", g_plant_list[l_ac].azw05_new, 10)
               NEXT FIELD azw01_new
            ELSE
               SELECT azw02 INTO g_plant_list[l_ac].azw02_new FROM azw_file 
                 WHERE azw01 = g_plant_list[l_ac].azw01_new 
               DISPLAY g_plant_list[l_ac].azw02_new TO azw02_new
            END IF
         END IF
         
      AFTER INPUT
         LET l_flag = 'N'
         FOR l_i = 1 TO g_plant_list.getLength()
             IF cl_null(g_plant_list[l_i].azw01_new) THEN
                CALL cl_err('','9033',0)
                CALL fgl_set_arr_curr(l_i)
                NEXT FIELD azw01_new
                EXIT FOR
             END IF
         END FOR
           
      ON ACTION help                             # H.說明
         CALL cl_show_help()
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice = "exit"
         EXIT INPUT

      ON ACTION cancel
         LET g_action_choice = "cancel"
         EXIT INPUT
            
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about      
         CALL cl_about() 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT  

      ON ACTION locale
         CALL cl_dynamic_locale()
         
   END INPUT
      
   CLOSE WINDOW p_plant_list_w
   CALL cl_set_act_visible("accept,cancel", TRUE)

   #如果是直接按離開或結束,認定它取消此建立schema作業,後續也不進入建立schema步驟
   IF g_action_choice = "exit" OR g_action_choice = "cancel" THEN
      RETURN FALSE
   END IF

   CALL cl_set_comp_visible("Page5", TRUE)
   DISPLAY ARRAY g_plant_list TO s_tbPlant.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
      
   RETURN TRUE
END FUNCTION  

#[
# Descriptions...: 新建實體DB時將打勾的Schema相關營運中心代碼全部找出來
# Date & Author..: 2011/09/28 by Jay
# Input Parameter: none
# Return Code....: 
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_create_schema_tbPlant_fill()
   DEFINE l_sql     STRING
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_j       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5

   #找出有存放資料在這個實體DB的所有營運中心,如:dsall就有DSALL,DSV1-1,DSV1-2,DSV1-3
   LET l_sql = "SELECT DISTINCT azw02, azw01, azw05 FROM azw_file ", 
               "  WHERE azw05 = ? "
   PREPARE tbPlant_fill_pre FROM l_sql
   DECLARE tbPlant_fill_curs CURSOR FOR tbPlant_fill_pre

   LET g_build_schema = ""   #紀錄已打勾的schema
   LET l_j = 1
   CALL g_plant_list.clear()
   
   FOR l_i = 1 TO g_list.getLength()
      IF g_list[l_i].sel = "Y" AND g_list[l_i].is_virtual = "N" THEN
         #紀錄已打勾的schema
         LET g_build_schema = g_build_schema, "'", g_list[l_i].schema, "',"
         OPEN tbPlant_fill_curs USING tm_arr[l_i].azp03_2
         IF STATUS THEN
            CALL cl_err("OPEN tbPlant_fill_curs:", STATUS, 1)
            CLOSE tbPlant_fill_curs
            RETURN FALSE
         END IF

         FOREACH tbPlant_fill_curs INTO g_plant_list[l_j].azw02_old, g_plant_list[l_j].azw01_old, g_plant_list[l_j].azw05_old
            IF SQLCA.SQLCODE THEN
               CALL cl_err('FOREACH:', SQLCA.SQLCODE, 1)    
               CLOSE tbPlant_fill_curs
               RETURN FALSE
            END IF

            #檢查被參考的資料庫代碼如果只有單一營運中心,直接預設新schema的營運中心(如:Muilt-DB架構的schema都是一對一,可以直接預設)
            #條件式直接利用登入DB(azw06)來檢查就可以了,因為登入DB=實體DB的話,代表此schema一定是實體DB
            SELECT COUNT(*) INTO l_cnt FROM azw_file 
              WHERE azw01 = g_plant_list[l_j].azw01_old AND azw06 = tm_arr[l_i].azp03_2 
            IF l_cnt = 1 THEN
               #如果登入DB也為實體DB
               SELECT azw01 INTO g_plant_list[l_j].azw01_new FROM azw_file 
                 WHERE azw06 = g_list[l_i].SCHEMA
               LET g_plant_list[l_j].azw02_new = g_list[l_i].legal
            END IF
         
            LET g_plant_list[l_j].azw05_new = g_list[l_i].schema
            LET l_j = l_j + 1
         END FOREACH
      END IF

      #也需一併紀錄虛擬DB被勾選建立的情形,避色等一下被return false
      IF g_list[l_i].sel = 'Y' AND g_list[l_i].is_virtual = "Y" THEN
         #紀錄已打勾的schema
         LET g_build_schema = g_build_schema, "'", g_list[l_i].schema, "',"
      END IF 
   END FOR
   CLOSE tbPlant_fill_curs
   CALL g_plant_list.deleteElement(l_j)

   IF g_build_schema.getCharAt(g_build_schema.getLength()) = "," THEN
      LET g_build_schema = g_build_schema.subString(1, g_build_schema.getLength() - 1)
   END IF

   #這裡應該可以找到準備要建立的Schema,如果沒有代表程式有錯,需要return false
   IF NOT cl_null(g_build_schema) THEN
      RETURN TRUE
   ELSE
      CALL cl_err("", "azz1010", 1)  
      RETURN FALSE
   END IF
END FUNCTION  

#[
# Descriptions...: 新建實體DB時將xxxlegal和xxxplant欄位資料Update成新的schema法人和營運中心資料
# Date & Author..: 2011/09/30 by Jay
# Input Parameter: none
# Return Code....: 
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_create_schema_update_value()
   DEFINE l_msg      STRING
   DEFINE l_sql             STRING
   DEFINE l_upd_sql         STRING
   DEFINE l_sch01           LIKE sch_file.sch01
   DEFINE l_sch02_legal     LIKE sch_file.sch02
   DEFINE l_sch02_plant     LIKE sch_file.sch02
   DEFINE l_i               LIKE type_file.num5

   #此段SQL語法是一次找出每個table的xxxlegal和xxxplant欄位名稱,避免一直呼叫db
   #括號中第一段是找有xxxlegal欄位名稱的table
   #     第二段是找有xxxplant欄位名稱的table
   #最後再將有xxxlegal欄位名稱為主要sql, 將二段sql語法LEFT OUTER JOIN在一起(這裡是定義成有xxxplant一定也要有xxxlegal)
   #就可以找出每個table是只有xxxlegal欄位,或是xxxlegal和xxxplant二個欄位都有
   LET l_sql = "SELECT l_sch01, l_sch02, p_sch02 FROM ", 
               "  ((SELECT l.sch01 AS l_sch01, l.sch02 AS l_sch02 FROM sch_file l WHERE l.sch02 LIKE '%legal') ",
               "    LEFT OUTER JOIN ",
               "   (SELECT p.sch01 AS p_sch01, p.sch02 AS p_sch02 FROM sch_file p WHERE p.sch02 LIKE '%plant') ",
               "    ON l_sch01 = p_sch01) "
   #---FUN-BB0118-----start-----
   #如果要建立的schema不為法人DB,就需要過濾掉財務模組的table
   #不需要Update這個table的Legal & Plant 的值
   #因為後面也會把這些財務模組table drop掉,create synonym到法人DB
   IF g_azp03_1 <> g_list[g_idx].legal_db CLIPPED THEN         	  
      LET l_sql = l_sql, " WHERE l_sch01 NOT IN ", 
                         "   (SELECT zta01 FROM zta_file ", 
                         "      WHERE zta02 = 'ds' AND zta03 IN (", cl_get_finance_in(), ") ", 
                         "        AND zta07 = 'T' AND zta09 <> 'Z') "
   END IF
   #---FUN-BB0118-----end-------
   LET l_sql = l_sql, " ORDER BY l_sch01 "   #FUN-BB0118 組字串調整
   
   PREPARE update_value_pre FROM l_sql
   DECLARE update_value_curs CURSOR FOR update_value_pre

   #將這個部份的log資料直接紀錄在today_xxx.log中,例如100119_ds99.log
   CALL g_log_ch.writeLine("")
   CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")   
   LET l_msg = g_azp03_1,":update xxxlegal and xxxplant vaule data."
   CALL g_log_ch.writeLine(l_msg)
   
   OPEN update_value_curs 
   IF STATUS THEN
      CALL cl_err("OPEN update_value_curs:", STATUS, 1)
      CLOSE update_value_curs
      LET l_msg = "Update failed. OPEN update_value_curs:", STATUS
      CALL g_log_ch.writeLine(l_msg)
      CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")
      RETURN
   END IF

   #準備Update 新schema的xxxlegal和xxxplant欄位資料
   FOREACH update_value_curs INTO l_sch01, l_sch02_legal, l_sch02_plant
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:', SQLCA.SQLCODE, 1)    
         CLOSE update_value_curs
         LET l_msg = "FOREACH:", SQLCA.SQLCODE
         CALL g_log_ch.writeLine(l_msg)
      END IF

      FOR l_i = 1 TO g_plant_list.getLength()
          IF g_plant_list[l_i].azw05_new = g_azp03_1 THEN
             LET l_upd_sql = "UPDATE ", s_dbstring(g_azp03_1), l_sch01,
                      "  SET ", l_sch02_legal, " = '", g_plant_list[l_i].azw02_new CLIPPED, "'"

             IF cl_null(l_sch02_plant) THEN
                LET l_upd_sql = l_upd_sql, "  WHERE ", l_sch02_legal, " = '", g_plant_list[l_i].azw02_old, "'"
             ELSE
                LET l_upd_sql = l_upd_sql, ", ", l_sch02_plant, " = '", g_plant_list[l_i].azw01_new CLIPPED, "'"
                LET l_upd_sql = l_upd_sql, "  WHERE ", l_sch02_plant, " = '", g_plant_list[l_i].azw01_old CLIPPED, "'"
             END IF

             #執行UPDATE程序
             TRY
                CALL g_log_ch.writeLine(l_upd_sql)
                EXECUTE IMMEDIATE l_upd_sql
                CALL g_log_ch.writeLine("UPDATE OK")
             CATCH
                LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
                CALL g_log_ch.writeLine(l_msg)
             END TRY

             #假如這個table只有xxxlegal欄位,那update只要做一次就可以了
             IF cl_null(l_sch02_plant) THEN
                EXIT FOR
             END IF  
          END IF
      END FOR
   END FOREACH
   CLOSE update_value_curs
END FUNCTION  
#---FUN-B90135---end-------
