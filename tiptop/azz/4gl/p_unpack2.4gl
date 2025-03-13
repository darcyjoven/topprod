# Prog. Version..: '5.30.06-13.04.15(00010)'     #
#
##################################################                                                                                  
# Description   : Patch 解包                                                                                                        
# Date & Author : 2007/03/05 by flowld                                                                                              
# FUN-790005    :過單                                                                                                                        
# FUN-790023    :過單
# FUN-7A0006    :過單
# TQC-7A0048    :過單
# Modify........: No.TQC-7A0016 07/10/10 By Mandy 筆誤調整
# Modify........: No.FUN-7A0011 07/10/10 By flowld gaz_file的筆誤調整
# Modify........: No.TQC-7B0012 07/11/01 By flowld informix調整寫法
# Modify........: No.TQC-7B0110 07/11/20 By flowld 
# Modify........: No.TQC-7C0065 07/12/07 By Mandy gal_file已客製的不應patch至客戶端
# Modify........: No.TQC-810092 08/01/31 By Mandy 更新p_link當gak01 in ('qry','sub','lib')時的處理
# Modify........: No.TQC-810087 08/02/01 By Mandy (1)開窗時,可開出客戶端$TOP/pack路徑下的所有.tar檔及所有的.gz檔
#                                                 (2)若選擇的檔案為.gz檔就先做解壓縮指令,再做其它動作
# Modify........: No.TQC-820020 08/02/22 By Mandy p_zl填單問題,gbd_file並未load成功
# Modify........: No.TQC-820024 08/02/25 By Mandy bn5自由路徑時的處理
# Modify........: No.TQC-840034 08/04/11 By Mandy 解包時,在做檔案搬移(mv)至某個新的目錄時,發現無此目錄,需先建立,再做搬移
# Modify........: No.FUN-830034 08/04/08 By saki 增加大版更入口
# Modify........: No.TQC-850040 08/06/04 By Flowld 備份全路徑文件時有漏失，引入IMPORT os修復此問題
# Modify........: No.FUN-860023 08/06/06 By Flowld modify patch for GP5.1
# Modify........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify........: No.FUN-860059 08/06/16 By Mandy 行業別程式問題
# Modify........: No.FUN-860102 08/06/26 By flowld 新增p_zl自動調用功能
                                                   #080625 by flowld
# Modify........: No.FUN-860116 08/07/01 By flowld #自動解包不秀畫面修改                                                   
# Modify........: No.TQC-870008 08/07/08 By flowld #自動解包BUG修正
# Modify........: No.FUN-870080 08/08/11 By flowld #新增詢問使用者DBA密碼功能
# Modify........: No.FUN-890036 08/09/08 By saki 自動編譯Link
# Modify........: No.TQC-890028 08/09/09 By saki 自動解包時忽略任何開窗
# Modify........: No.TQC-8A0015 08/10/08 By Mandy 上好patch後,若上gak_file有十筆,其中僅有一筆失敗,但卻所有上gak_file的更新狀況皆show失敗
# Modify........: No.TQC-8A0012 08/10/27 By clover 客戶已有鏈結gal04='Y',將不鏈結標準程式
# Modify........: No.FUN-8A0115 08/10/28 By clover GP資料同步新增TABLE 選項
# Modify........: No.TQC-8A0077 08/10/29 By Mandy p_all_act 只填 "5.p_all_act   gbd_file"的資料時,上patch會不成功
# Modify........: No.FUN-8C0005 08/12/01 By saki 增加wsd_file...wsi_file資料同步
# Modify........: No.CHI-8C0007 08/12/03 By claire gal_file,gak_file於informix區解包驗證資料無法寫入
# Modify........: No.CHI-8C0021 08/12/15 By claire show_array筆數限制由參數控制,造成參數設定過小,清單無法完整產生,故在此設定3000
# Modify........: No.FUN-8C0067 08/12/15 By saki 增加wah_file...waj_file,waa_file...wac_file資料同步
# Modify........: No.CHI-920020 09/02/05 By jamie 修改waa_file,wab_file,wac_file資料同步SQL
# Modify........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify........: No.TQC-920102 09/02/27 By Dido 增加 zaw14-18 
# Modify........: No.FUN-950103 09/06/25 By joyce alter.sql清單須區分ds資料庫(alter_ds.sql)及非ds資料庫(alter_others.sql)
# Modify........: No.FUN-960050 09/07/06 By joyce 資料同步新增"W"選項
# Modify........: No.FUN-970083 09/08/26 By joyce 1.開窗讓user選擇要自動做alter table的資料庫
#                                                 2.備份user選擇的資料庫
#                                                 3.解包時自動做alter table動作，並產生log清單
# Modify........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify........: No:FUN-A10049 10/01/11 By joyce 程式中被誤加dbo寫法，須將程式還原
# Modify........: No:FUN-A10136 10/01/26 By joyce for GP 5.2調整打包及解包程式
# Modify........: No:FUN-A30105 10/03/29 By joyce 資料同步新增"X"選項(gee_file)
# Modify........: No:FUN-A40027 10/04/09 By joyce for AP 與 DB分開的客戶調整程式，user須輸入sys密碼
# Modify........: No:FUN-A50044 10/05/27 By joyce for GP 5.2集團架構修改
# Modify........: No:FUN-A60053 10/07/26 By joyce 資料同步新增"Y"選項(zta_file)
# Modify........: No:FUN-A80066 10/08/11 By joyce 新增可讓解包人員選擇要刪除的patch備份檔的功能
# Modify........: No:FUN-A80074 10/08/13 By joyce 1.列出alter的資料庫清單時不應只限於標準出貨資料庫
#                                                 2.列出alter資料庫清單後，新增"全選"及"取消全選"功能
# Modify........: No:FUN-A90064 11/01/12 By joyce for MSV資料庫調整patch程式
# Modify........: No:FUN-B60010 11/06/03 By joyce 新增table時，須grant權限給虛擬資料庫
# Modify........: No:FUN-B60121 11/06/23 By joyce 新增Genero Report機制及資料同步選項新增"Z"、"A1"、"A2"選項
# Modify........: No:FUN-B70023 11/07/10 By joyce Genero Report 過單機制新增多樣版及套表圖檔
# Modify........: No:FUN-B60112 11/07/20 By joyce for 5.3切版調整
# Modify........: No:FUN-BA0022 11/10/05 By joyce 建立目錄時無法一次建立多層，須一層一層建立
# Modify........: No:FUN-BB0011 11/11/04 By joyce 資料同步新增選項"A3"
# Modify........: No:TQC-BB0079 11/11/21 By joyce 調整gdm_file及wan_file程式段
# Modify........: No:FUN-C20069 12/02/20 By joyce GP 5.3 GWC & GDC合併架構調整
# Modify........: No:FUN-C20108 12/04/02 By joyce 資料同步(p_syc)新增備註欄位
# Modify........: No:DEV-C40001 12/04/09 By joyce 資料同步選項"A1"加過gfs_file的資料
# Modify........: No:TQC-BB0134 12/06/21 By jt_chen 調整zm資料更新、自動切換營運中心、、alter錯誤清單匯出Excel指向網址修改
# Modify........: No:TQC-C10004 12/06/21 By jt_chen 修正ZM程式段- 當目錄代號(zm01)不存在時,無法新增.
# Modify........: NO:TQC-BB0216 12/06/21 By jt_chen p_unpack2優化
#                                                   1.介面式方式設定
#                                                   2.彈出視窗詢問需備份的資料庫-寫入資料庫
#                                                   3.alter自動將modify為NOT NULL的語法，再加上判斷更新主機的舊資料是否該欄位值有NULL，若有則update為預設值
#                                                   4.alter時判斷drop constraint時，能檢核更新主機該constraint是否有index，若有則刪除
#                                                   5.alter錯誤清單略過重複alter新增的欄位及ods的錯誤
#                                                   6.alter錯誤寫到資料庫，再重新alter時參考錯誤記錄只alter錯誤的部分
#                                                   7.更新程式/資料段，不彈出提示確認視窗、更新清單視窗，更新清單直接產生檔案至目錄 
#                                                   8.alter自動將modify為NOT NULL的語法，再加上判斷更新主機的舊資料是否該欄位值有NULL，若有則update為預設值
#                                                   9.alter錯誤寫到資料庫，再重新alter時參考錯誤記錄只alter錯誤的部分
# Modify........: No:TQC-C30059 12/06/22 By jt_chen (1)修正command宣告型態長度過短(2)增加判斷若無alter_ERR.xls檔案時，不做mv的動作，避免mv-$TEMPDIR(3)增加略過執行pat04的SQL重複的錯誤
# Modify........: No:TQC-C50150 12/06/25 By jt_chen 增加寫入user的同步資料欄位schema與產中不同時，LOAD txt檔造成失敗的紀錄訊息。(load.log)
# Modify........: No:TQC-BB0113 12/06/25 By jt_chen 增加ZM顯示未更新的功能
# Modify........: No:TQC-C70041 12/07/05 By jt_chen log增加記錄到成功總筆數、INSERT失敗的當筆資料、UPDATE失敗的當筆資料。以檢查是否完整LOAD至客戶家。
# Modify........: No:FUN-C70035 12/07/11 By joyce   調整刪除patchtemp語言別資料的程式段
# Modify........: No:TQC-C80051 12/08/08 By jt_chen GP5.30 patch中，應對應客戶所購買的語言，排除GR多語言的部分。
# Modify........: No:TQC-C70132 12/08/16 By jt_chen 改用SYSTEMP做備份的動作
# Modify........: No:FUN-C90054 12/09/12 By joyce 調整syc06的長度由varchar(50)改為varchar(100)
# Modify........: No:FUN-CB0095 12/11/21 By laura 資料同步選項"B8"加過gdr_file及gds_file的資料for p_xglang
# Modify........: No:TQC-C30110 12/11/30 By jt_chen 只追比對$PGLPROFILE的部分
# Modify........: No:TQC-CA0019 12/12/31 By jt_chen 修正比對$FGLPROFILE後,刪除MARK營運中心的ARRAY計算異常(BUG);以及更改為抓取Schema的字眼
# Modify........: No:FUN-D10131 13/02/05 By joyce 資料同步新增"B9"與"C1"選項
# Modify........: No:TQC-D30073 13/03/29 By jt_chen 調整ods

#################################################                                                                                  
 
IMPORT os     #FUN-830034
DATABASE ds                                                                                                                         
  
# FUN-790005
# FUN-790023
# FUN-7A0006
# TQC-7A0048
# FUN-860116
GLOBALS "../../config/top.global"
 
#-----------TQC-BB0216 add start --------------------
GLOBALS

DEFINE ms_codeset      STRING            
DEFINE ms_locale       STRING            
DEFINE g_query_prog    LIKE gcy_file.gcy01    
DEFINE g_query_cust    LIKE gcy_file.gcy05    

END GLOBALS
   
DEFINE  g_hidden          DYNAMIC ARRAY OF LIKE type_file.chr1     
DEFINE  g_ifchar          DYNAMIC ARRAY OF LIKE type_file.chr1     
DEFINE  g_mask            DYNAMIC ARRAY OF LIKE type_file.chr1     
DEFINE  g_quote           STRING     
DEFINE  tsconv_cmd        STRING     
DEFINE  l_channel         base.Channel
DEFINE  l_str             STRING
DEFINE  xls_name          STRING
DEFINE  cnt_table         LIKE type_file.num10    
DEFINE  l_win_name        STRING                 
DEFINE  cnt_header        LIKE type_file.num10     
DEFINE  g_gab07           LIKE gab_file.gab07     
DEFINE  g_sort            RECORD
                          column        LIKE type_file.num5,     
                          type          STRING,                 
                          name          STRING                  
                          END RECORD
DEFINE  g_pat03_cnt       LIKE type_file.num10   
DEFINE  delete_chk        LIKE type_file.chr1      
DEFINE  g_pwd             VARCHAR(20)                     
DEFINE  g_pwd_sys         VARCHAR(20)                     
#-----------TQC-BB0216 add end --------------------
DEFINE  g_tarname         VARCHAR(40)
DEFINE  g_cnt             LIKE type_file.num10
DEFINE  g_max_rec_o       LIKE type_file.num10   #CHI-8C0021 
DEFINE  g_rec_b           LIKE type_file.num10
DEFINE  l_ac              LIKE type_file.num5
DEFINE  g_a_t             LIKE type_file.chr30
DEFINE  g_quit            LIKE type_file.chr1
DEFINE  g_db_type         LIKE type_file.chr3  
DEFINE  g_link            LIKE type_file.chr1
DEFINE  g_convert         LIKE type_file.chr10
DEFINE  g_envlang         STRING
DEFINE  g_envcust         STRING
DEFINE  l_zl27            LIKE type_file.chr1
DEFINE  tm              DYNAMIC ARRAY OF RECORD
                          select    LIKE type_file.chr1,
                          row       LIKE type_file.num5,
                          alter     LIKE type_file.chr1,
                          zl05      LIKE type_file.chr10,
                          zl09      LIKE type_file.chr7,
                          zl01      LIKE type_file.dat,
                          zl08      LIKE type_file.chr10,
                          zl00      LIKE type_file.chr10,
                          zl45      LIKE type_file.chr1,
                          zl15      LIKE type_file.chr1000,
                          zl06      LIKE type_file.chr1000
                        END RECORD
# No:FUN-A80066 ---start---
DEFINE  ts              DYNAMIC ARRAY OF RECORD
                          sel       LIKE type_file.chr1,
                          filename  LIKE type_file.chr50
                        END RECORD
# No:FUN-A80066 --- end ---
DEFINE  g_show_msg      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          cust   LIKE type_file.chr1,
                          syc01  LIKE type_file.chr10,                                  
                          syc03  LIKE type_file.chr9,          #"OVERWRITE","DELETE"   
                          syc05  LIKE type_file.chr10,                               
                          syc06  LIKE type_file.chr100,        # No:FUN-C90054                        
                          syc07  LIKE type_file.chr50,
                          syc08  LIKE type_file.chr50,         # No:FUN-C20108
                          gaz03  LIKE gaz_file.gaz03,            
                          pack_status  LIKE type_file.chr10    #TQC-BB0113 modify                  
                        END RECORD  
DEFINE g_show_msg_curr  DYNAMIC ARRAY OF RECORD
                          cust  LIKE type_file.chr1,
                          syc01 LIKE type_file.chr10,
                          syc03 LIKE type_file.chr9,
                          syc05 LIKE type_file.chr10,
                          syc06 LIKE type_file.chr100,   # No:FUN-C90054
                          syc07 LIKE type_file.chr50,
                          syc08 LIKE type_file.chr50,    # No:FUN-C20108
                          zln03 LIKE type_file.chr6,     # No:FUN-C20069
                          zln04 LIKE type_file.chr6,     # No:FUN-C20069
                          gaz03 LIKE gaz_file.gaz03
                        END RECORD
DEFINE g_show_alter_list DYNAMIC ARRAY OF RECORD
                          zs01 LIKE zs_file.zs01,
                          zsdb LIKE type_file.chr14,     # No.FUN-950103
                          zs06 LIKE zs_file.zs06,
                          zs08 LIKE zs_file.zs08,
                          zs04 LIKE zs_file.zs04,
                          zs03 LIKE zs_file.zs03
                         END RECORD       
DEFINE g_patchname       STRING                #No.FUN-830034
DEFINE g_bpatch          LIKE type_file.num5   #No.FUN-830034
DEFINE   g_argv1        STRING
DEFINE   g_argv2        STRING
# No.FUN-970083 ---start---
DEFINE   g_dblist        DYNAMIC ARRAY OF RECORD
             #chk         LIKE type_file.chr1,	                	#TQC-BB0216 --- mark
       	     alter_chk    LIKE type_file.chr1,		                #TQC-BB0216 --- add
             backup_chk   LIKE type_file.chr1,		                #TQC-BB0216 --- add
             azp03       LIKE azp_file.azp03,
             type        LIKE type_file.chr1    #1:ds  2:法人DB  3:法人DB下所屬的DB   4:虛擬DB   5:ods資料庫   # No:FUN-A50044
                         END RECORD
# No.TQC-BB0216 ---start---
DEFINE   g_pat_alt_list DYNAMIC ARRAY OF RECORD
             alter_chk   LIKE type_file.chr1,
             backup_chk  LIKE type_file.chr1,
             azp03       LIKE azp_file.azp03,
             type        LIKE type_file.chr1
                        END RECORD                            #用來記錄當pat_file.pat03有此次patch單號的時候 所show的單身                         
DEFINE   g_alter_err_db DYNAMIC ARRAY OF RECORD
             db          LIKE azp_file.azp03,
             no          LIKE pat_file.pat02,
             command     LIKE pat_file.pat04                  #TQC-C30059 modify pat04 
                        END RECORD			      #用來紀錄當pat_file所SELECT出的陣列
# No.TQC-BB0216 ---end---        
# No:FUN-A50044 ---start---
DEFINE   g_dblist_pre    DYNAMIC ARRAY OF RECORD
             #chk        LIKE type_file.chr1,                           # TQC-BB0216 mark
             alter_chk   LIKE type_file.chr1,	                        # TQC-BB0216 add 
             azp03       LIKE azp_file.azp03,
             type        LIKE type_file.chr1    #1:ds  2:法人DB  3:法人DB下所屬的DB   4:虛擬DB   5:ods資料庫   # No:FUN-A50044
                         END RECORD
# No:FUN-A50044 --- end ---
DEFINE   g_topdir        STRING
DEFINE   g_show_alt_msg DYNAMIC ARRAY OF RECORD
             azp03       LIKE azp_file.azp03,
             no          LIKE type_file.num5,
             tarname     VARCHAR(40),
             command     LIKE pat_file.pat04,                
             errcode     LIKE type_file.chr14,
             ze03        LIKE ze_file.ze03
                        END RECORD
DEFINE   g_show_err      LIKE type_file.num5
DEFINE   g_cnt2          LIKE type_file.num5
DEFINE   g_tcp_servername     LIKE type_file.chr30
DEFINE   g_area               LIKE type_file.chr30
# No.FUN-970083 --- end ---
DEFINE   gc_channel      base.Channel         #TQC-C50150 add
DEFINE   gs_channel      base.Channel         #TQC-C70041 add
DEFINE   g_gay01         VARCHAR(1)           #TQC-C80051 add

MAIN
   DEFINE   l_str          STRING
   DEFINE   l_ds4gl_path   STRING
   DEFINE   li_result      LIKE type_file.num5
   DEFINE   ls_ver         STRING
   DEFINE   l_cmd          STRING
   DEFINE   l_a            LIKE type_file.chr50
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   #---------TQC-BB0134 add start-----------
   IF g_db_type = "ORA" THEN
      CLOSE DATABASE
   ELSE
      DISCONNECT ALL
   END IF
   LET g_dbs = "ds"
   CALL p_unpack2_set_erpdb()
   #---------TQC-BB0134 add end---------- 
   OPEN WINDOW pack_w AT 1,1 WITH FORM "azz/42f/p_unpack2"
      CALL cl_ui_init()
 
   LET g_db_type = DB_GET_DATABASE_TYPE()
   LET g_bpatch = FALSE   #No.FUN-830034
   LET g_argv1 =  ARG_VAL(1)
   LET g_argv2 =  ARG_VAL(2)
     
   LET g_topdir = FGL_GETENV('TOP')         # No.FUN-970083
   LET g_area = FGL_GETENV('ORACLE_SID')    # No.FUN-970083
 
   CALL fp_unpack()      
#  CALL menu()
       
   CLOSE WINDOW pack_w
 
   #No.FUN-830034 --start--
   IF g_bpatch THEN
      CALL p_unpack2_bpatch()
   END IF
   #No.FUN-830034 ---end---
      
END MAIN
 
 
FUNCTION menu()
  DEFINE l_cmd   STRING
 
  MENU''
     ON ACTION exit
        EXIT MENU
     
     ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
        EXIT MENU   
     
     ON ACTION insert 
        CLEAR FORM
        CALL fp_unpack()
       
     #TQC-860017 start
     ON ACTION about
        CALL cl_about()
 
     ON ACTION controlg
        CALL cl_cmdask()
     
     ON ACTION help
        CALL cl_show_help()
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE MENU
     #TQC-860017 end
  END MENU
END FUNCTION
 
 
FUNCTION fp_unpack()
   DEFINE   l_str          STRING                                                                                                   
   DEFINE   l_ds4gl_path   STRING                                                                                                   
   DEFINE   li_result      LIKE type_file.num5                                                                                                 
   DEFINE   l_tempdir      STRING                                                                                                      
   DEFINE   l_cmd          STRING
#  DEFINE   l_db_type      STRING            
   DEFINE   ls_a           STRING                                                                                       
   DEFINE   l_a            LIKE type_file.chr30
   DEFINE   l_tardir       LIKE type_file.chr30
#  DEFINE   l_sql          LIKE type_file.chr1000
   DEFINE   l_sql          STRING      #NO.FUN-910082
   DEFINE   l_cnt          LIKE type_file.num5  
   DEFINE   l_i            LIKE type_file.num5
   DEFINE   l_date         LIKE type_file.dat
   DEFINE   l_time         LIKE type_file.chr8
   DEFINE   l_channel      base.Channel
   
   DEFINE   lc_box         ui.ComboBox
   DEFINE   l_tarnm        STRING   
   DEFINE   l_cbitems      STRING
   DEFINE   l_packpath     STRING
   DEFINE   l_topdir       STRING
   DEFINE   l_title        STRING
   DEFINE   l_check        LIKE type_file.num5  #TQC-7B0110 add
   DEFINE   l_orasid       STRING               #TQC-7B0110 add 
   DEFINE   l_flow         LIKE type_file.chr10
   DEFINE   l_cont         STRING
   DEFINE   l_tarname      VARCHAR(40)
   DEFINE   l_pthno        VARCHAR(40)  
   DEFINE   l_row          LIKE type_file.num5   
   DEFINE   l_path         STRING
   DEFINE   l_last         STRING               #TQC-810087 add
   DEFINE   l_show_flow    LIKE type_file.chr12 #071001 add by mandy
#  DEFINE   l_db_type      VARCHAR(3)           #080623
   DEFINE   l_lang         VARCHAR(20)          #080623
   DEFINE   l_dbenv        VARCHAR(20)          #080623
   DEFINE   l_systype      VARCHAR(8)           #080623
  #DEFINE   l_gay01        VARCHAR(1)           #080623     #TQC-C80051 mark
   DEFINE   l_quit         VARCHAR(1)           #FUN-860102
   DEFINE   l_pwd          VARCHAR(20)          #FUN-870080
   DEFINE   l_ze03         VARCHAR(250)         #FUN-870080
   DEFINE   l_err          INTEGER              #FUN-870080
   DEFINE   lc_result      LIKE type_file.num5  #FUN-970083
   DEFINE   lc_cnt         LIKE type_file.num5  #FUN-970083
   DEFINE   lc_cnt1        LIKE type_file.num5  #FUN-970083
   DEFINE   l_pwd_sys      VARCHAR(20)          #FUN-A40027
   DEFINE   l_ze03_sys     VARCHAR(250)         #FUN-A40027
   DEFINE   l_azw06        LIKE azw_file.azw06  #FUN-A50044
   DEFINE   l_pack_path    STRING               #FUN-A90064
   DEFINE   l_unpack_path  STRING               #FUN-A90064
   DEFINE   l_backup_path  STRING               #FUN-A90064
   DEFINE   l_tarname_path STRING               #FUN-A90064
   DEFINE   l_h            LIKE type_file.num5  #FUN-A90064
   DEFINE   l_idx          LIKE type_file.num5  #FUN-A90064
   DEFINE   l_sql_file_1   STRING               #FUN-A90064
   DEFINE   l_file         STRING               #FUN-A90064
   DEFINE   l_backup_file  STRING               #FUN-A90064
   DEFINE   l_source_file  STRING               #FUN-A90064
   DEFINE   l_copied_file  STRING               #FUN-A90064
   DEFINE   l_delete_file  STRING               #FUN-A90064
   DEFINE   l_result       LIKE type_file.num5  #FUN-A90064
   DEFINE   l_sql_file_2   STRING               #FUN-C20069
   DEFINE   l_kind         VARCHAR(1)           #FUN-C20069
                           # l_kind代表意義：
                           # --> l_kind = "1"   表示ds與wds都有alter的狀況
                           # --> l_kind = "2"   表示ds有alter但wds沒有alter
                           # --> l_kind = "3"   表示ds沒有alter但wds有alter
                           # --> l_kind = "4"   表示ds與wds都沒有alter的狀況
   DEFINE   ls_db_dir      STRING               #TQC-BB0216
   DEFINE   ls_db_file     STRING               #TQC-BB0216
   DEFINE   l_ac           LIKE type_file.num5  #TQC-BB0216
   DEFINE   ls_cnt         LIKE type_file.chr1  #TQC-C30059
 
   LET l_topdir  = FGL_GETENV('TOP')
   LET l_tempdir = FGL_GETENV('TEMPDIR') 
   LET l_ds4gl_path= FGL_GETENV('DS4GL')
   LET l_orasid = FGL_GETENV('ORACLE_SID')
   LET l_systype = ''
   LET l_lang = FGL_GETENV('LANG')
   LET l_lang = UPSHIFT(l_lang)
   LET l_pack_path = os.Path.join(FGL_GETENV('TOP'),"pack")   #FUN-A90064
   LET l_unpack_path = os.Path.join(FGL_GETENV('TOP'),"unpack")   #FUN-A90064
 
   SELECT COUNT(DISTINCT gay01) INTO g_gay01 FROM gay_file WHERE gay01='1'                    #TQC-C80051 modify g_gay01
   IF g_db_type = 'ORA' THEN 
      LET l_dbenv = FGL_GETENV('ORACLE_SID')
      IF NOT cl_null(l_dbenv) THEN 
         CASE 
            WHEN (l_lang = 'ZH_TW.BIG5' AND g_gay01 = '1')                                    #TQC-C80051 modify g_gay01 
               LET l_systype = 'ORA_1_B5'
            WHEN (l_lang = 'ZH_TW.BIG5' AND g_gay01 = '0')                                    #TQC-C80051 modify g_gay01
               LET l_systype = 'ORA_0_B5'
            WHEN ((l_lang = 'ZH_CN.GB2312' OR l_lang = 'ZH_CN.GB18030') AND g_gay01 = '1')    #TQC-C80051 modify g_gay01
               LET l_systype = 'ORA_1_GB'
            WHEN ((l_lang = 'ZH_CN.GB2312' OR l_lang = 'ZH_CN.GB18030') AND g_gay01 = '0')    #TQC-C80051 modify g_gay01
               LET l_systype = 'ORA_0_GB'
            WHEN (l_lang = 'EN_US.UTF8' AND g_gay01 = '1')                                    #TQC-C80051 modify g_gay01
               LET l_systype = 'ORA_1_UN'
            WHEN (l_lang = 'EN_US.UTF8' AND g_gay01 = '0')                                    #TQC-C80051 modify g_gay01
               LET l_systype = 'ORA_0_UN'
         END CASE
      END IF              
   END IF
 
   #080623 by flowld
   LET g_link = "N"
 
   #080625 by flowld  FUN-860102
   IF NOT cl_null(g_argv1) THEN 
      LET l_a = g_argv1 CLIPPED     #g_argv1 not with '.tar.gz'
      LET g_tarname = l_a 
      LET g_link = g_argv2 CLIPPED  #No.FUN-890036
   ELSE               
   #080625 by flowld

     # TQC-BB0216 --- mark start ---
      # No:FUN-A80066 ---start---
     #IF cl_prompt(0,0,"是否要進行刪除patch備份檔的動作？") THEN
     #   CALL p_unpack2_delete_patch_backup()
     #END IF
      # No:FUN-A80066 --- end ---
     # TQC-BB0216 --- mark END ---
   
      INPUT l_a,g_link WITHOUT DEFAULTS FROM a,b
 
         BEFORE INPUT 
            LET  lc_box = ui.ComboBox.forName("a")
            CALL lc_box.clear()         
            LET l_channel = base.Channel.create()
            #TQC-810087 (1)開窗時,可開出客戶端$PACK路徑下的所有.tar檔及所有的.gz檔

            # No:FUN-A90064 ---start---
            CALL os.Path.dirsort("name",1)
            LET l_h = os.Path.diropen(l_pack_path)
            WHILE l_h > 0
               LET l_cbitems = os.Path.dirnext(l_h)
               IF l_cbitems IS NULL THEN
                  EXIT WHILE
               END IF
               IF l_cbitems = "." OR l_cbitems = ".." THEN
                  CONTINUE WHILE
               END IF

               LET l_idx = l_cbitems.getIndexOf(".tar",1)
               IF l_idx > 0 THEN
                  LET l_last  = l_cbitems.subString(l_cbitems.getLength()-3,l_cbitems.getLength())
                  IF l_last = '.tar' THEN
                     LET  l_tarnm = l_cbitems.subString(1,l_cbitems.getLength()-4)
                  ELSE
                     LET  l_tarnm = l_cbitems.subString(1,l_cbitems.getLength()-7)
                  END IF
                  CALL lc_box.addItem(l_tarnm,l_cbitems)
               END IF

            END WHILE
            CALL os.Path.dirclose(l_h)
            # No:FUN-A90064 --- end ---
 
         AFTER FIELD a
            #TQC-810087--add---str---
            IF cl_null(l_a) THEN
               NEXT FIELD a
            END IF
            #TQC-810087--add---end---
 
            LET ls_a = l_a CLIPPED

            # No:FUN-C70035 ---modify start---
            # 因為現在都只有中英文版的patch包，所以改成只檢查patch包的DB型態，而不細到語言別
            #080623 by flowld
         #  IF ls_a.subString(22,29) != l_systype THEN 
            IF ls_a.subString(22,24) != cl_db_get_database_type() THEN 
               CALL cl_err(ls_a.subString(22,29),'azz-805',1)   
               NEXT FIELD a
            END IF    
            #080623 by flowld
            # No:FUN-C70035 --- modify end ---
 
            #No.FUN-830034 --start-- 加入大版更判斷
            IF ls_a.subString(1,7) = "bpatch_" THEN
               LET g_patchname = ls_a.trim()
               LET g_bpatch = TRUE
               EXIT INPUT
            END IF 
            #No.FUN-830034 ---end---
 
            IF ls_a.subString(1,2) = "A-" THEN 
               SELECT substr(MAX(pth07),3,10) INTO l_flow FROM pth_file
                WHERE pth07 LIKE "A-%" AND substr(pth07,16,2) = '30'      #FUN-860023   # FUN-B60121   #FUN-BB0011
 
               IF cl_null(l_flow) THEN 
                  LET l_flow = "0000000001"
               ELSE   
                  LET l_flow = l_flow + 1 
                  LET l_flow = l_flow USING '&&&&&&&&&&'
               END IF   
               IF ls_a.subString(3,12) != l_flow THEN 
                  #071001 mod by mandy--str--
                  #ERROR 'Try another pack! Expect flow number: ',l_flow
                  #為目前應先上的patch單號,請依patch單號順序上patch!
                  LET l_show_flow = 'A-',l_flow CLIPPED
                  CALL cl_err(l_show_flow,'azz-801',1)
                  #071001 mod by mandy--end--
 
                  NEXT FIELD a
               ELSE        
                  LET g_tarname = l_a CLIPPED
               END IF
            ELSE 
               LET g_tarname = l_a CLIPPED
            END IF                                                                                              
           
         ON ACTION cancel
            RETURN
 
         ON ACTION comp_link
            IF g_link = "Y" THEN
               LET g_link = "N"
            ELSE
               LET g_link = "Y"
            END IF 
            DISPLAY g_link TO FORMONLY.b
 
         #TQC-860017 start
         ON ACTION about
            CALL cl_about()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION help
            CALL cl_show_help()
  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         #TQC-860017 end
          
      END INPUT
   END IF    #FUN-860102
 
   #No.FUN-830034 --start--
   IF g_bpatch THEN
      RETURN
   END IF
   #No.FUN-830034 ---end---
 
   #080625 by flowld     
   #TQC-810087---mod---str---
   #(2)若選擇的檔案為.gz就先做解壓縮指令,再做其它動作
   # No:FUN-A90064 ---start---
   IF os.Path.chdir(l_pack_path) THEN
      IF os.Path.separator() = "/" THEN    # 表示為UNIX的作業系統
         LET l_cmd = "gunzip ",os.Path.join(l_pack_path,l_a||".tar.gz")
         RUN l_cmd
      END IF
      LET l_cmd = "tar xvf ",os.Path.join(l_pack_path,l_a||".tar")
      RUN l_cmd
   ELSE
      LET l_cmd = "change directory error"
      CALL cl_err(l_cmd,"!",1)
   END IF
   # No:FUN-A90064 --- end ---
   #TQC-810087---mod---end---
   DISPLAY "解壓OK！" 
     
   #由pat_file尋找是否有此次patch單號的紀錄,區別出是否有做過ALTER及有ALTER錯誤的動作    # TQC-BB0216 add
   SELECT COUNT(*) INTO g_pat03_cnt FROM pat_file WHERE pat03 = g_tarname               # TQC-BB0216 add

   IF g_pat03_cnt = 0 THEN                                                              # TQC-BB0216 add
      # 若pat_file.pat03無此PATCH相關紀錄,則執行以下(沒有ALTER錯誤)                     # TQC-BB0216 add
      # No.FUN-970083 ---start---
      # 先判斷該patch包是否有需要做alter table動作
      # 檢查該patch包中alter_ds.sql的檔案是否存在
      LET l_backup_path = os.Path.join(os.Path.join(l_unpack_path,"db_backup"),g_tarname)   # No:FUN-A90064
      LET l_sql_file_1 = os.Path.join(os.Path.join(l_pack_path,g_tarname),"alter_ds.sql")   # No:FUN-A90064
      LET l_sql_file_2 = os.Path.join(os.Path.join(l_pack_path,g_tarname),"alter_wds.sql")  # No:FUN-C20069

      # 因為wds為web區使用的DB，有可能會獨立alter，因此若只有alter_wds.sql存在的話也需要alter   # No:FUN-C20069
     #IF os.Path.exists(l_sql_file) THEN    # 表示有找到
      IF os.Path.exists(l_sql_file_1) OR os.Path.exists(l_sql_file_2) THEN    # 表示有找到   # No:FUN-C20069
         IF g_db_type = "IFX" THEN
            # 因informix有DB備份的問題(只要有user連線到該DB就無法備份)，
            # 與銀和討論後決議informix客戶仍須手動alter table動作，不由程式執行
            LET l_cmd = "informix無自動 alter table 機制，請手動 alter table 完後再進行後續解包動作"
            CALL p_unpack2_show_msg(l_cmd)
         ELSE
            # 系統自動執行alter table動作
            LET lc_result = TRUE
            LET l_kind = NULL

            # No:FUN-C20069 ---start---
            # 因為wds為web區使用的DB，有可能會獨立alter，因此若只有alter_wds.sql存在的話也需要alter
            CASE
               WHEN os.Path.exists(l_sql_file_1) AND os.Path.exists(l_sql_file_2)
                  LET l_kind = "1"       # ds與wds都有alter的狀況

               WHEN os.Path.exists(l_sql_file_1) AND NOT os.Path.exists(l_sql_file_2)
                  LET l_kind = "2"       # ds有alter但wds沒有alter

               WHEN NOT os.Path.exists(l_sql_file_1) AND os.Path.exists(l_sql_file_2)
                  LET l_kind = "3"       # ds沒有alter但wds有alter

               OTHERWISE
                  LET l_kind = "4"       # ds與wds都沒有alter的狀況
            END CASE

            CALL p_unpack2_alter_db(l_kind) RETURNING lc_result
            # No:FUN-C20069 --- end ---

           #IF NOT lc_result THEN     # 表有異常   #TQC-BB0216 mark
            CASE lc_result   #TQC-BB0216 add
               WHEN 0        #TQC-BB0216 add
                  LET l_cmd = "1.ds或是wds資料庫都不需要做alter的動作  \n",
                              "2.取消自動alter作業 \n",
                              "3.自動執行alter table作業時有異常，請手動排除後再繼續執行本支作業"
                  CALL p_unpack2_show_msg(l_cmd)
                  RETURN
           #ELSE             #TQC-BB0216 mark
               WHEN 1        #TQC-BB0216 add
                  # 自動執行r.s2指令(因較難判別r.s2是否有成功，故不紀錄訊息)
                  # 1.若alter table沒有異常則只針對user所選的資料庫進行r.s2動作
                     # 以下步驟2. 已於TQC-BB0216取消                                     #TQC-BB0216 add
                     # 2.若alter table有錯，當user手動處理完後再繼續解包時，             #TQC-BB0216 mark
                     #   程式已無法判別當時user所選擇的資料庫，                          #TQC-BB0216 mark
                     #   會以alter table前所做的備份檔作為r.s2的依據                     #TQC-BB0216 mark
              #LET lc_cnt = g_dblist.getLength()                                         #TQC-BB0216 mark
              #IF lc_cnt > 0 THEN	                                                 #TQC-BB0216 mark							    							   
                  FOR lc_cnt1 = 1 TO g_dblist.getLength()
                     #IF g_dblist[lc_cnt1].chk = "Y" THEN                                #TQC-BB0216 mark
                     IF g_dblist[lc_cnt1].alter_chk = "Y" THEN	                         #TQC-BB0216 add
                        # Hiko表示虛擬資料庫及ods資料庫做備份，但不需做r.s2動作
                        IF g_dblist[lc_cnt1].type = "4" OR g_dblist[lc_cnt1].type = "5" THEN
                           CONTINUE FOR
                        END IF

                        # No:FUN-C20069 ---start---
                        IF g_dblist[lc_cnt1].azp03 = "wds" THEN
                           LET l_cmd = "r.sw ",g_dblist[lc_cnt1].azp03 CLIPPED
                           RUN l_cmd
                        # No:FUN-C20069 --- end ---
                        ELSE
                           # No:FUN-A90064 ---start---
                           IF os.Path.separator() = "/" THEN    # 表示UNIX系統
                              LET l_cmd = "r.s2 ",g_dblist[lc_cnt1].azp03 CLIPPED
                              RUN l_cmd
                           ELSE
                              LET l_cmd = "rs2 ",g_dblist[lc_cnt1].azp03 CLIPPED
                              RUN l_cmd
                           END IF
                           # No:FUN-A90064 --- end ---
                        END IF
                     END IF
                  END FOR
              #ELSE        #TQC-BB0216 mark
               WHEN 2   #TQC-BB0216 add
                  LET l_cmd = "取消執行p_unpack2解包作業。"
                  CALL p_unpack2_show_msg(l_cmd)
                  RETURN
            END CASE
         END IF
               # TQC-BB0216 -- mark start -- 
               #       ELSE
               #      # No:FUN-A90064 ---start---
               #      CALL os.Path.dirsort("name",1)
               #     LET l_h = os.Path.diropen(l_backup_path)
               #     WHILE l_h > 0
               #        LET l_file = os.Path.dirnext(l_h)
               #        IF l_file IS NULL THEN
               #          EXIT WHILE
               #        END IF
               #        IF l_file = "." OR l_file = ".." THEN
               #           CONTINUE WHILE
               #        END IF
               #
               #        LET l_idx = l_file.getIndexOf(".dmp",1)
               #        IF l_idx > 0 THEN
               #           LET l_backup_file = os.Path.rootname(l_file)
               #     
               #        # Hiko表示虛擬資料庫及ods資料庫做備份，但不需做r.s2動作
               #           IF l_backup_file = "ods" THEN
               #              CONTINUE WHILE
               #           END IF
               #     
               #        # 檢查該資料庫是否為虛擬資料庫
               #           LET l_azw06 = l_backup_file
               #            SELECT COUNT(*) INTO l_i FROM azw_file
               #             WHERE azw05 <> azw06
               #             AND azw06 = l_azw06
               #            IF l_i > 0 THEN
               #               CONTINUE WHILE
               #            END IF

               #        # No:FUN-C20069 ---start---
               #        IF l_backup_file = "wds" THEN
               #           LET l_cmd = "r.sw ",l_backup_file CLIPPED
               #           RUN l_cmd
               #        # No:FUN-C20069 --- end ---
               #        ELSE
               #           IF os.Path.separator() = "/" THEN    # 表示UNIX系統
               #              LET l_cmd = "r.s2 ",l_backup_file
               #              RUN l_cmd
               #           ELSE
               #              LET l_cmd = "rs2 ",l_backup_file
               #              RUN l_cmd
               #           END IF
               #         END IF
               #     END IF
               #  END WHILE
               #  CALL os.Path.dirclose(l_h)
               #  # No:FUN-A90064 --- end ---
               #TQC-BB0216 -- mark end --
      ELSE
         LET l_cmd = "此 patch 包：",g_tarname CLIPPED," 無 alter table"
         CALL p_unpack2_show_msg(l_cmd)
   # No.FUN-970083 --- end ---
 
         #FUN-870080                                                                                                            
         # No:FUN-A90064 ---mark start---
         # 從GP 5.25開始，patchtemp為預設出貨DB，因此上patch時不須重新建立
         # 因上patch需求，仍須暫時由此shell重建patchtemp   11/07/11
         SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'zta-030' AND ze02 = g_lang
         SELECT ze03 INTO l_ze03_sys FROM ze_file WHERE ze01 = 'zta-046' AND ze02 = g_lang   # No:FUN-A40027
         LET l_err = 1
         WHILE l_err
            IF cl_null(g_argv1) THEN    #No.TQC-890028   # No:FUN-A40027
               PROMPT l_ze03 CLIPPED FOR g_pwd ATTRIBUTE(INVISIBLE)
               CALL ui.interface.refresh()
               # No:FUN-C20069 ---start---
               IF INT_FLAG THEN
                  LET INT_FLAG = FALSE
                  RETURN
               END IF
               # No:FUN-C20069 --- end ---
            END IF                          #No.TQC-890028

            # No:FUN-A40027 ---start---
            IF cl_null(g_argv1) THEN    # No:FUN-A40027
               PROMPT l_ze03_sys CLIPPED FOR g_pwd_sys ATTRIBUTE(INVISIBLE)
               CALL ui.interface.refresh()
               # No:FUN-C20069 ---start---
               IF INT_FLAG THEN
                  LET INT_FLAG = FALSE
                  RETURN
               END IF
               # No:FUN-C20069 --- end ---
            END IF
            # No:FUN-A40027 --- end ---

            LET l_cmd = "sh ",l_ds4gl_path,"/bin/patchtemp.sh ",g_pwd CLIPPED," ",g_pwd_sys CLIPPED," | tee  /tmp/patchtemp.chk"    # No:FUN-A40027
            RUN l_cmd                                                                                                              
            LET l_cmd = "grep 'Wrong passwd' /tmp/patchtemp.chk"                                                                            
            RUN l_cmd RETURNING l_err                                                                                              
            IF l_err = 0 THEN                                                                                                      
               LET l_err = 1 
               CALL cl_err(g_pwd,'azz-865',1)                                                                                                        
            ELSE                                                                                                                   
               LET l_err = 0                                                                                                       
            END IF
         END WHILE                                                                                                              
      END IF
   END IF 
   # NO. TQC-BB0216 --- add start ---
   IF g_pat03_cnt > 0 THEN                            
      CALL p_unpack2_pat_alter() RETURNING lc_result
     #IF NOT lc_result THEN     # 表有異常   #TQC-BB0216 mark
      CASE lc_result   #TQC-BB0216 add
         WHEN 0   #TQC-BB0216 add
            LET l_cmd = "自動執行pat_file.pat04的SQL指令作業時有異常，請手動排除後再繼續執行本支作業"
            CALL p_unpack2_show_msg(l_cmd)
            RETURN   
     #ELSE   #TQC-BB0216 mark
         WHEN 1   #TQC-BB0216 add
            # 自動執行r.s2指令(因較難判別r.s2是否有成功，故不紀錄訊息)
            # 若alter table沒有異常則只針對user所選的資料庫進行r.s2動作
           #LET lc_cnt = g_pat_alt_list.getLength()  #TQC-BB0216 mark
           #IF lc_cnt > 0 THEN  #TQC-BB0216 mark
               FOR lc_cnt1 = 1 TO g_pat_alt_list.getLength()
                  IF g_pat_alt_list[lc_cnt1].alter_chk = "Y" THEN   
                     IF g_dblist[lc_cnt1].azp03 = "wds" THEN
                        LET l_cmd = "r.sw ",g_dblist[lc_cnt1].azp03 CLIPPED
                        RUN l_cmd
                     ELSE
                        IF os.Path.separator() = "/" THEN    # 表示UNIX系統
                           LET l_cmd = "r.s2 ",g_pat_alt_list[lc_cnt1].azp03 CLIPPED
                           RUN l_cmd
                        ELSE
                           LET l_cmd = "rs2 ",g_pat_alt_list[lc_cnt1].azp03 CLIPPED
                           RUN l_cmd
                        END IF
                     END IF
                  END IF
               END FOR
           #ELSE  #TQC-BB0216 mark	
         WHEN 2   #TQC-BB0216 add
            IF NOT cl_prompt(0,0,"是否繼續執行p_unpack2解包作業\n\n是-  繼續解包作業\n否-  離開") THEN 
               LET l_cmd = "取消執行p_unpack2解包作業。"
               CALL p_unpack2_show_msg(l_cmd)
               RETURN
            END IF
      END CASE
   END IF 
  # No:FUN-A90064 --- mark end ---
  #NO. TQC-BB0216 --- add end ---
   #TQC-C50150 -- add start -- #OPEN channel 紀錄LOAD失敗訊息
   LET gc_channel = base.Channel.create()
   LET l_cmd = os.Path.join(os.Path.join(os.Path.join(l_topdir,"pack"),g_tarname),"load.log")
   CALL gc_channel.openFile(l_cmd,"w")
   CALL gc_channel.setDelimiter("")
   #TQC-C50150 -- add end --
   #TQC-C70041 -- add start -- #OPEN channel 紀錄LOAD同步資料成功筆數
   LET gs_channel = base.Channel.create()
   LET l_cmd = os.Path.join(os.Path.join(os.Path.join(l_topdir,"pack"),g_tarname),"Success.log")
   CALL gs_channel.openFile(l_cmd,"w")
   CALL gs_channel.setDelimiter("")
   #TQC-C70041 -- add end --
   #FUN-870080

   # No:FUN-A90064 --- start---
   IF os.Path.chdir(l_tempdir) THEN
      LET l_tarname_path = os.Path.join(l_pack_path,g_tarname)
      CALL os.Path.dirsort("name",1)
      LET l_h = os.Path.diropen(l_tarname_path)
      WHILE l_h > 0
         LET l_file = os.Path.dirnext(l_h)
         IF l_file IS NULL THEN
            EXIT WHILE
         END IF
         IF l_file = "." OR l_file = ".." THEN
            CONTINUE WHILE
         END IF

         IF l_file.subString(1,5) <> "patch" THEN
            CONTINUE WHILE
         END IF

         LET l_source_file = os.Path.join(l_tarname_path,l_file)
         LET l_copied_file = os.Path.join(l_tempdir,l_file)
         LET l_idx = l_file.getIndexOf(".txt",1)
         IF l_idx > 0 THEN
            CALL os.Path.copy(l_source_file,l_copied_file) RETURNING l_i
            IF NOT l_i THEN
               DISPLAY "file ",l_source_file," copied to ",l_copied_file," was false."
            END IF
         END IF

         LET l_idx = l_file.getIndexOf(".log",1)
         IF l_idx > 0 THEN
            CALL os.Path.copy(l_source_file,l_copied_file) RETURNING l_i
            IF NOT l_i THEN
               DISPLAY "file ",l_source_file," copied to ",l_copied_file," was false."
            END IF
         END IF
      END WHILE
      CALL os.Path.dirclose(l_h)
   ELSE
      LET l_cmd = "change directory ",l_tempdir," error"
      CALL cl_err(l_cmd,"!",1)
   END IF
   # No:FUN-A90064 --- end ---

   # No:FUN-A90064 ---start---
   # 因從GP 5.25開始，patchtemp為預設出貨DB，
   # 為避免上patch時patchtemp中相關table已有資料，
   # 所以在LOAD資料之前先刪除table資料

   DELETE FROM patchtemp.pzl_file
   DELETE FROM patchtemp.ze_file 
   DELETE FROM patchtemp.zz_file 
   DELETE FROM patchtemp.zm_file 
   DELETE FROM patchtemp.gap_file
   DELETE FROM patchtemp.gbd_file
   DELETE FROM patchtemp.gae_file
   DELETE FROM patchtemp.gak_file
   DELETE FROM patchtemp.gal_file
   DELETE FROM patchtemp.gaq_file
   DELETE FROM patchtemp.gab_file
   DELETE FROM patchtemp.gac_file
   DELETE FROM patchtemp.gav_file
   DELETE FROM patchtemp.gat_file
   DELETE FROM patchtemp.gaz_file
   DELETE FROM patchtemp.wsa_file
   DELETE FROM patchtemp.wsb_file
   DELETE FROM patchtemp.zaa_file
   DELETE FROM patchtemp.zab_file
   DELETE FROM patchtemp.gao_file
   DELETE FROM patchtemp.gba_file
   DELETE FROM patchtemp.gbb_file
   DELETE FROM patchtemp.gax_file
   DELETE FROM patchtemp.gbf_file
   DELETE FROM patchtemp.pyc_file
   DELETE FROM patchtemp.pzs_file
   DELETE FROM patchtemp.zad_file
   DELETE FROM patchtemp.zae_file
   DELETE FROM patchtemp.wca_file
   DELETE FROM patchtemp.wcb_file
   DELETE FROM patchtemp.wcc_file
   DELETE FROM patchtemp.wcd_file
   DELETE FROM patchtemp.zaw_file
   DELETE FROM patchtemp.zav_file
   DELETE FROM patchtemp.zai_file
   DELETE FROM patchtemp.zaj_file
   DELETE FROM patchtemp.zak_file
   DELETE FROM patchtemp.zal_file
   DELETE FROM patchtemp.zam_file
   DELETE FROM patchtemp.zan_file
   DELETE FROM patchtemp.zao_file
   DELETE FROM patchtemp.zap_file
   DELETE FROM patchtemp.zaq_file
   DELETE FROM patchtemp.zar_file
   DELETE FROM patchtemp.zas_file
   DELETE FROM patchtemp.zat_file
   DELETE FROM patchtemp.zau_file
   DELETE FROM patchtemp.zay_file
   DELETE FROM patchtemp.wsm_file
   DELETE FROM patchtemp.wsn_file
   DELETE FROM patchtemp.wso_file
   DELETE FROM patchtemp.wsp_file
   DELETE FROM patchtemp.wsr_file  #FUN-8A0115 
   DELETE FROM patchtemp.wss_file  #FUN-8A0115 
   DELETE FROM patchtemp.wst_file  #FUN-8A0115 
   DELETE FROM patchtemp.wgf_file  #FUN-8A0115 
   DELETE FROM patchtemp.wsd_file
   DELETE FROM patchtemp.wse_file
   DELETE FROM patchtemp.wsf_file
   DELETE FROM patchtemp.wsg_file
   DELETE FROM patchtemp.wsh_file
   DELETE FROM patchtemp.wsi_file
   DELETE FROM patchtemp.wah_file
   DELETE FROM patchtemp.wai_file
   DELETE FROM patchtemp.waj_file
   DELETE FROM patchtemp.waa_file
   DELETE FROM patchtemp.wab_file
   DELETE FROM patchtemp.wac_file
   DELETE FROM patchtemp.wad_file
   DELETE FROM patchtemp.wae_file
   DELETE FROM patchtemp.wan_file
   DELETE FROM patchtemp.gee_file
   DELETE FROM patchtemp.zta_file     # No:FUN-A60053
   DELETE FROM patchtemp.wao_file     # No:FUN-B60121
   DELETE FROM patchtemp.gdw_file     # No:FUN-B60121
   DELETE FROM patchtemp.gdm_file     # No:FUN-B60121
   DELETE FROM patchtemp.gfs_file     # No:DEV-C40001
   DELETE FROM patchtemp.gdo_file     # No:FUN-B60121
   DELETE FROM patchtemp.gfn_file     # No:FUN-BB0011
   DELETE FROM patchtemp.gfm_file     # No:FUN-BB0011
   DELETE FROM patchtemp.gfp_file     # No:FUN-BB0011
   DELETE FROM patchtemp.gdk_file     # No:FUN-BB0011
   DELETE FROM patchtemp.gdl_file     # No:FUN-BB0011
   # No:FUN-A90064 --- end ---
   # No:FUN-C20069 ---start---
   DELETE FROM patchtemp.wzb_file
   DELETE FROM patchtemp.wzc_file
   DELETE FROM patchtemp.wzd_file
   DELETE FROM patchtemp.wzf_file
   DELETE FROM patchtemp.wzh_file
   DELETE FROM patchtemp.wzi_file
   DELETE FROM patchtemp.wzl_file
   DELETE FROM patchtemp.wzm_file
   DELETE FROM patchtemp.wzo_file
   DELETE FROM patchtemp.wzs_file
   DELETE FROM patchtemp.wzz_file
   DELETE FROM patchtemp.wya_file
   DELETE FROM patchtemp.wyb_file
   DELETE FROM patchtemp.wyc_file
   # No:FUN-C20069 --- end ---
   DELETE FROM patchtemp.gdr_file     # No:FUN-CB0095
   DELETE FROM patchtemp.gds_file     # No:FUN-CB0095
   DELETE FROM patchtemp.gbl_file     # No:FUN-D10131

   LOAD FROM "patch_pzl.log"   INSERT INTO patchtemp.pzl_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.pzl_file: LOAD .txt檔時,產生錯誤，請檢查pzl_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_ze.txt"    INSERT INTO patchtemp.ze_file 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.ze_file: LOAD .txt檔時,產生錯誤，請檢查ze_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_zz.txt"    INSERT INTO patchtemp.zz_file 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zz_file: LOAD .txt檔時,產生錯誤，請檢查zz_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zm.txt"    INSERT INTO patchtemp.zm_file 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zm_file: LOAD .txt檔時,產生錯誤，請檢查zm_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gap.txt"   INSERT INTO patchtemp.gap_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gap_file: LOAD .txt檔時,產生錯誤，請檢查gap_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gbd.txt"   INSERT INTO patchtemp.gbd_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gbd_file: LOAD .txt檔時,產生錯誤，請檢查gbd_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gae.txt"   INSERT INTO patchtemp.gae_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gae_file: LOAD .txt檔時,產生錯誤，請檢查gae_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gak.txt"   INSERT INTO patchtemp.gak_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gak_file: LOAD .txt檔時,產生錯誤，請檢查gak_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gal.txt"   INSERT INTO patchtemp.gal_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gal_file: LOAD .txt檔時,產生錯誤，請檢查gal_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gaq.txt"   INSERT INTO patchtemp.gaq_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gaq_file: LOAD .txt檔時,產生錯誤，請檢查gaq_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gab.txt"   INSERT INTO patchtemp.gab_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gab_file: LOAD .txt檔時,產生錯誤，請檢查gab_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gac.txt"   INSERT INTO patchtemp.gac_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gac_file: LOAD .txt檔時,產生錯誤，請檢查gac_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gav.txt"   INSERT INTO patchtemp.gav_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gav_file: LOAD .txt檔時,產生錯誤，請檢查gav_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gat.txt"   INSERT INTO patchtemp.gat_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gat_file: LOAD .txt檔時,產生錯誤，請檢查gat_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gaz.txt"   INSERT INTO patchtemp.gaz_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gaz_file: LOAD .txt檔時,產生錯誤，請檢查gaz_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsa.txt"   INSERT INTO patchtemp.wsa_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsa_file: LOAD .txt檔時,產生錯誤，請檢查wsa_file的schema"
      CALL gc_channel.write(l_cmd)	  
   END IF 
   LOAD FROM "patch_wsb.txt"   INSERT INTO patchtemp.wsb_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsb_file: LOAD .txt檔時,產生錯誤，請檢查wsb_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zaa.txt"   INSERT INTO patchtemp.zaa_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zaa_file: LOAD .txt檔時,產生錯誤，請檢查zaa_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_zab.txt"   INSERT INTO patchtemp.zab_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zab_file: LOAD .txt檔時,產生錯誤，請檢查zab_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_gao.txt"   INSERT INTO patchtemp.gao_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gao_file: LOAD .txt檔時,產生錯誤，請檢查gao_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gba.txt"   INSERT INTO patchtemp.gba_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gba_file: LOAD .txt檔時,產生錯誤，請檢查gba_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gbb.txt"   INSERT INTO patchtemp.gbb_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gbb_file: LOAD .txt檔時,產生錯誤，請檢查gbb_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gax.txt"   INSERT INTO patchtemp.gax_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gax_file: LOAD .txt檔時,產生錯誤，請檢查gax_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gbf.txt"   INSERT INTO patchtemp.gbf_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gbf_file: LOAD .txt檔時,產生錯誤，請檢查gbf_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_pyc.log"   INSERT INTO patchtemp.pyc_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.pyc_file: LOAD .txt檔時,產生錯誤，請檢查pyc_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_pzs.log"   INSERT INTO patchtemp.pzs_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.pzs_file: LOAD .txt檔時,產生錯誤，請檢查pzs_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zad.txt"   INSERT INTO patchtemp.zad_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zad_file: LOAD .txt檔時,產生錯誤，請檢查zad_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zae.txt"   INSERT INTO patchtemp.zae_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zae_file: LOAD .txt檔時,產生錯誤，請檢查zae_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wca.txt"   INSERT INTO patchtemp.wca_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wca_file: LOAD .txt檔時,產生錯誤，請檢查wca_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wcb.txt"   INSERT INTO patchtemp.wcb_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wcb_file: LOAD .txt檔時,產生錯誤，請檢查wcb_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wcc.txt"   INSERT INTO patchtemp.wcc_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wcc_file: LOAD .txt檔時,產生錯誤，請檢查wcc_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wcd.txt"   INSERT INTO patchtemp.wcd_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wcd_file: LOAD .txt檔時,產生錯誤，請檢查wcd_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zaw.txt"   INSERT INTO patchtemp.zaw_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zaw_file: LOAD .txt檔時,產生錯誤，請檢查zaw_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zav.txt"   INSERT INTO patchtemp.zav_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zav_file: LOAD .txt檔時,產生錯誤，請檢查zav_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zai.txt"   INSERT INTO patchtemp.zai_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zai_file: LOAD .txt檔時,產生錯誤，請檢查zai_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zaj.txt"   INSERT INTO patchtemp.zaj_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zaj_file: LOAD .txt檔時,產生錯誤，請檢查zaj_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zak.txt"   INSERT INTO patchtemp.zak_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zak_file: LOAD .txt檔時,產生錯誤，請檢查zak_file的schema"
      CALL gc_channel.write(l_cmd) 
   END IF
   LOAD FROM "patch_zal.txt"   INSERT INTO patchtemp.zal_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zal_file: LOAD .txt檔時,產生錯誤，請檢查zal_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zam.txt"   INSERT INTO patchtemp.zam_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zam_file: LOAD .txt檔時,產生錯誤，請檢查zam_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zan.txt"   INSERT INTO patchtemp.zan_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zan_file: LOAD .txt檔時,產生錯誤，請檢查zan_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zao.txt"   INSERT INTO patchtemp.zao_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zao_file: LOAD .txt檔時,產生錯誤，請檢查zao_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zap.txt"   INSERT INTO patchtemp.zap_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zap_file: LOAD .txt檔時,產生錯誤，請檢查zap_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zaq.txt"   INSERT INTO patchtemp.zaq_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zaq_file: LOAD .txt檔時,產生錯誤，請檢查zaq_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zar.txt"   INSERT INTO patchtemp.zar_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zar_file: LOAD .txt檔時,產生錯誤，請檢查zar_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zas.txt"   INSERT INTO patchtemp.zas_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zas_file: LOAD .txt檔時,產生錯誤，請檢查zas_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zat.txt"   INSERT INTO patchtemp.zat_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zat_file: LOAD .txt檔時,產生錯誤，請檢查zat_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zau.txt"   INSERT INTO patchtemp.zau_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zau_file: LOAD .txt檔時,產生錯誤，請檢查zau_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zay.txt"   INSERT INTO patchtemp.zay_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zay_file: LOAD .txt檔時,產生錯誤，請檢查zay_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsm.txt"   INSERT INTO patchtemp.wsm_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsm_file: LOAD .txt檔時,產生錯誤，請檢查wsm_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsn.txt"   INSERT INTO patchtemp.wsn_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsn_file: LOAD .txt檔時,產生錯誤，請檢查wsn_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wso.txt"   INSERT INTO patchtemp.wso_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wso_file: LOAD .txt檔時,產生錯誤，請檢查wso_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsp.txt"   INSERT INTO patchtemp.wsp_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsp_file: LOAD .txt檔時,產生錯誤，請檢查wsp_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsr.txt"   INSERT INTO patchtemp.wsr_file  #FUN-8A0115 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsr_file: LOAD .txt檔時,產生錯誤，請檢查wsr_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_wss.txt"   INSERT INTO patchtemp.wss_file  #FUN-8A0115 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wss_file: LOAD .txt檔時,產生錯誤，請檢查wss_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_wst.txt"   INSERT INTO patchtemp.wst_file  #FUN-8A0115 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wst_file: LOAD .txt檔時,產生錯誤，請檢查wst_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   LOAD FROM "patch_wgf.txt"   INSERT INTO patchtemp.wgf_file  #FUN-8A0115 
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wgf_file: LOAD .txt檔時,產生錯誤，請檢查wgf_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF 
   #No.FUN-8C0005 --start--
   LOAD FROM "patch_wsd.txt"   INSERT INTO patchtemp.wsd_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsd_file: LOAD .txt檔時,產生錯誤，請檢查wsd_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wse.txt"   INSERT INTO patchtemp.wse_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wse_file: LOAD .txt檔時,產生錯誤，請檢查wse_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsf.txt"   INSERT INTO patchtemp.wsf_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsf_file: LOAD .txt檔時,產生錯誤，請檢查wsf_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsg.txt"   INSERT INTO patchtemp.wsg_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsg_file: LOAD .txt檔時,產生錯誤，請檢查wsg_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsh.txt"   INSERT INTO patchtemp.wsh_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsh_file: LOAD .txt檔時,產生錯誤，請檢查wsh_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wsi.txt"   INSERT INTO patchtemp.wsi_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsi_file: LOAD .txt檔時,產生錯誤，請檢查wsi_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   #No.FUN-8C0005 ---end---
   #No.FUN-8C0067 --start--
   LOAD FROM "patch_wah.txt"   INSERT INTO patchtemp.wah_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wsh_file: LOAD .txt檔時,產生錯誤，請檢查wsh_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wai.txt"   INSERT INTO patchtemp.wai_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wai_file: LOAD .txt檔時,產生錯誤，請檢查wai_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_waj.txt"   INSERT INTO patchtemp.waj_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.waj_file: LOAD .txt檔時,產生錯誤，請檢查waj_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_waa.txt"   INSERT INTO patchtemp.waa_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.waa_file: LOAD .txt檔時,產生錯誤，請檢查waa_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wab.txt"   INSERT INTO patchtemp.wab_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wab_file: LOAD .txt檔時,產生錯誤，請檢查wab_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wac.txt"   INSERT INTO patchtemp.wac_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wac_file: LOAD .txt檔時,產生錯誤，請檢查wac_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   #No.FUN-8C0067 ---end---
   # No.FUN-960050 ---start---
   LOAD FROM "patch_wad.txt"   INSERT INTO patchtemp.wad_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wad_file: LOAD .txt檔時,產生錯誤，請檢查wad_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wae.txt"   INSERT INTO patchtemp.wae_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wae_file: LOAD .txt檔時,產生錯誤，請檢查wae_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wan.txt"   INSERT INTO patchtemp.wan_file
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wan_file: LOAD .txt檔時,產生錯誤，請檢查wan_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   # No.FUN-960050 --- end ---
   LOAD FROM "patch_gee.txt"   INSERT INTO patchtemp.gee_file     # No:FUN-A30105
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gee_file: LOAD .txt檔時,產生錯誤，請檢查gee_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_zta.txt"   INSERT INTO patchtemp.zta_file     # No:FUN-A60053
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.zta_file: LOAD .txt檔時,產生錯誤，請檢查zta_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wao.txt"   INSERT INTO patchtemp.wao_file     # No:FUN-B60121
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wao_file: LOAD .txt檔時,產生錯誤，請檢查wao_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdw.txt"   INSERT INTO patchtemp.gdw_file     # No:FUN-B60121
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gdw_file: LOAD .txt檔時,產生錯誤，請檢查gdw_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdm.txt"   INSERT INTO patchtemp.gdm_file     # No:FUN-B60121
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gdm_file: LOAD .txt檔時,產生錯誤，請檢查gdm_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gfs.txt"   INSERT INTO patchtemp.gfs_file     # No:DEV-C40001
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gfs_file: LOAD .txt檔時,產生錯誤，請檢查gfs_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdo.txt"   INSERT INTO patchtemp.gdo_file     # No:FUN-B60121
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gdo_file: LOAD .txt檔時,產生錯誤，請檢查gdo_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gfn.txt"   INSERT INTO patchtemp.gfn_file     # No:FUN-BB0011
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gfn_file: LOAD .txt檔時,產生錯誤，請檢查gfn_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gfm.txt"   INSERT INTO patchtemp.gfm_file     # No:FUN-BB0011
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gfm_file: LOAD .txt檔時,產生錯誤，請檢查gfm_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gfp.txt"   INSERT INTO patchtemp.gfp_file     # No:FUN-BB0011
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gfp_file: LOAD .txt檔時,產生錯誤，請檢查gfp_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdk.txt"   INSERT INTO patchtemp.gdk_file     # No:FUN-BB0011
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gdk_file: LOAD .txt檔時,產生錯誤，請檢查gdk_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdl.txt"   INSERT INTO patchtemp.gdl_file     # No:FUN-BB0011
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.gdl_file: LOAD .txt檔時,產生錯誤，請檢查gdl_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzb.txt"   INSERT INTO patchtemp.wzb_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzb_file: LOAD .txt檔時,產生錯誤，請檢查wzb_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzc.txt"   INSERT INTO patchtemp.wzc_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzc_file: LOAD .txt檔時,產生錯誤，請檢查wzc_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzd.txt"   INSERT INTO patchtemp.wzd_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzd_file: LOAD .txt檔時,產生錯誤，請檢查wzd_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzf.txt"   INSERT INTO patchtemp.wzf_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzf_file: LOAD .txt檔時,產生錯誤，請檢查wzf_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzh.txt"   INSERT INTO patchtemp.wzh_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzh_file: LOAD .txt檔時,產生錯誤，請檢查wzh_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzi.txt"   INSERT INTO patchtemp.wzi_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzi_file: LOAD .txt檔時,產生錯誤，請檢查wzi_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzl.txt"   INSERT INTO patchtemp.wzl_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzl_file: LOAD .txt檔時,產生錯誤，請檢查wzl_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzm.txt"   INSERT INTO patchtemp.wzm_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzm_file: LOAD .txt檔時,產生錯誤，請檢查wzm_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzo.txt"   INSERT INTO patchtemp.wzo_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzo_file: LOAD .txt檔時,產生錯誤，請檢查wzo_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzs.txt"   INSERT INTO patchtemp.wzs_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzs_file: LOAD .txt檔時,產生錯誤，請檢查wzs_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wzz.txt"   INSERT INTO patchtemp.wzz_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wzz_file: LOAD .txt檔時,產生錯誤，請檢查wzz_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wya.txt"   INSERT INTO patchtemp.wya_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wya_file: LOAD .txt檔時,產生錯誤，請檢查wya_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wyb.txt"   INSERT INTO patchtemp.wyb_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wyb_file: LOAD .txt檔時,產生錯誤，請檢查wyb_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_wyc.txt"   INSERT INTO patchtemp.wyc_file     # No:FUN-C20069
   IF STATUS <> 0 THEN   #TQC-C50150 add
      LET l_cmd = "patchtemp.wyc_file: LOAD .txt檔時,產生錯誤，請檢查wyc_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gdr.txt"   INSERT INTO patchtemp.gdr_file     # No:FUN-CB0095
   IF STATUS <> 0 THEN   
      LET l_cmd = "patchtemp.gdr_file: LOAD .txt檔時,產生錯誤，請檢查gdr_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gds.txt"   INSERT INTO patchtemp.gds_file     # No:FUN-CB0095
   IF STATUS <> 0 THEN 
      LET l_cmd = "patchtemp.gds_file: LOAD .txt檔時,產生錯誤，請檢查gds_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF
   LOAD FROM "patch_gbl.txt"   INSERT INTO patchtemp.gbl_file     # No:FUN-D10131
   IF STATUS <> 0 THEN 
      LET l_cmd = "patchtemp.gbl_file: LOAD .txt檔時,產生錯誤，請檢查gbl_file的schema"
      CALL gc_channel.write(l_cmd)
   END IF


   # No:FUN-C70035 ---modify start---
   # 在把資料LOAD到patchtemp後才去刪除英文的語言別資料 (如果客戶沒購買英文語言包的話)
   # 現在patch包只提供中英文版的，在上到客戶家後才去檢查客戶是否有購買英文語言包，
   # 如果沒有買的話，就把patch包中屬於英文的資料刪掉
   #cut lang 1
   SELECT COUNT(*) INTO l_i  FROM gay_file WHERE gay01 = '1'  #TQC-7A0016
 
   IF l_i = 0 THEN
      DELETE  FROM  patchtemp.ze_file   WHERE  ze02  = '1'
      DELETE  FROM  patchtemp.gbd_file  WHERE  gbd03 = '1'
      DELETE  FROM  patchtemp.gae_file  WHERE  gae03 = '1'
      DELETE  FROM  patchtemp.gaq_file  WHERE  gaq02 = '1'
      DELETE  FROM  patchtemp.gat_file  WHERE  gat02 = '1'
      DELETE  FROM  patchtemp.gaz_file  WHERE  gaz02 = '1'
      DELETE  FROM  patchtemp.zaa_file  WHERE  zaa03 = '1'
      DELETE  FROM  patchtemp.zab_file  WHERE  zab04 = '1'
      DELETE  FROM  patchtemp.gba_file  WHERE  gba04 = '1'
      DELETE  FROM  patchtemp.gbb_file  WHERE  gbb04 = '1'
      DELETE  FROM  patchtemp.gbf_file  WHERE  gbf02 = '1'
      DELETE  FROM  patchtemp.zad_file  WHERE  zad03 = '1'
      DELETE  FROM  patchtemp.zae_file  WHERE  zae05 = '1'
      DELETE  FROM  patchtemp.zaw_file  WHERE  zaw06 = '1'
      DELETE  FROM  patchtemp.zal_file  WHERE  zal03 = '1'
      DELETE  FROM  patchtemp.wan_file  WHERE  wan05 = '1'    # No:FUN-960050
      DELETE  FROM  patchtemp.gee_file  WHERE  gee03 = '1'    # No:FUN-A30105
   #  DELETE  FROM  patchtemp.zta_file  WHERE  zta01 = '1'    # No:FUN-A60053
      DELETE  FROM  patchtemp.gdm_file  WHERE  gdm03 = '1'    # No:FUN-B60121
      DELETE  FROM  patchtemp.gfs_file  WHERE  gfs02 = '1'    # No:DEV-C40001
      DELETE  FROM  patchtemp.gfp_file  WHERE  gfp03 = '1'    # No:FUN-BB0011
      DELETE  FROM  patchtemp.wzm_file  WHERE  wzm07 = '1'    # No:FUN-C20069
      DELETE  FROM  patchtemp.wzh_file  WHERE  wzh02 = '1'    # No:FUN-C20069
      DELETE  FROM  patchtemp.wzf_file  WHERE  wzf03 = '1'    # No:FUN-C20069
      DELETE  FROM  patchtemp.wya_file  WHERE  wya03 = '1'    # No:FUN-C20069
      DELETE  FROM  patchtemp.gfs_file  WHERE  gfs02 = '1'    # No:DEV-C40001
      DELETE  FROM  patchtemp.gds_file  WHERE  gds02 = '1'    # No:FUN-CB0095
   END IF
   # No:FUN-C70035 --- modify end ---

   # No:FUN-A90064 ---start---
   # 刪除暫存區的patch_*.txt及patch_*.log
   CALL os.Path.dirsort("name",1)
   LET l_h = os.Path.diropen(l_tempdir)
   WHILE l_h > 0
      LET l_file = os.Path.dirnext(l_h)
      IF l_file IS NULL THEN
         EXIT WHILE
      END IF
      IF l_file = "." OR l_file = ".." THEN
         CONTINUE WHILE
      END IF

      IF l_file.subString(1,5) <> "patch" THEN
         CONTINUE WHILE
      END IF

      LET l_idx = l_file.getIndexOf(".txt",1)
      IF l_idx > 0 THEN
         LET l_delete_file = os.Path.join(l_tempdir,l_file)
         CALL os.Path.delete(l_delete_file) RETURNING l_result
         IF NOT l_result THEN   #TQC-BB0216 add NOT
            DISPLAY "delete file error:",l_delete_file
         END IF
      END IF

      LET l_idx = l_file.getIndexOf(".log",1)
      IF l_idx > 0 THEN
         LET l_delete_file = os.Path.join(l_tempdir,l_file)
         CALL os.Path.delete(l_delete_file) RETURNING l_result
         IF NOT l_result THEN   #TQC-BB0216 add NOT
            DISPLAY "delete file error:",l_delete_file
         END IF
      END IF
   END WHILE
   CALL os.Path.dirclose(l_h)
   # No:FUN-A90064 --- end ---
                                                                                                       
   #backup db
   # No:FUN-A90064 ---start---
   LET l_file = os.Path.join(l_tarname_path,"exp_dssys.dmp")
   CALL os.Path.exists(l_file) RETURNING li_result
   # No:FUN-A90064 --- end ---
   IF NOT li_result THEN    # 表示不存在
      IF os.Path.separator() = "/" THEN   # 表示UNIX系統  # No:FUN-A90064
        #TQC-C70132 -- mark start --
        ##TQC-7B0110  --add--l_orasid--
        #LET l_cmd = "cd ",l_topdir CLIPPED,"/pack/",g_tarname CLIPPED,
        #            ";exp ds/ds@",l_orasid CLIPPED,"  tables=ze_file,zz_file,zm_file,gap_file,gbd_file,gae_file,",
        #            "gak_file,gal_file,gaq_file,gab_file,gac_file,gav_file,gat_file,gaz_file,",
        #            "wsa_file,wsb_file,zaa_file,zab_file,gao_file,gba_file,gbb_file,gax_file,",
        #            "gbf_file,zad_file,zae_file,wca_file,wcb_file,wcc_file,wcd_file,zaw_file,",
        #            "zav_file,zai_file,zaj_file,zak_file,zal_file,zam_file,zan_file,zao_file,",
        #            "zap_file,zaq_file,zar_file,zas_file,zat_file,zau_file,zay_file,wsm_file,wsn_file,",
        #            "wso_file,wsp_file,wsr_file,wss_file,wst_file,wgf_file,",    #FUN-8A0115
        #            "pth_file,wsd_file,wse_file,wsf_file,wsg_file,wsh_file,wsi_file, ",  #No.FUN-8C0005
        #            "wah_file,wai_file,waj_file,waa_file,wab_file,wac_file,wad_file,wae_file,wan_file,gee_file, ",      #No.FUN-8C0067   # No.FUN-960050  # No:FUN-A30105
        #            "zta_file,wao_file,gdw_file,gdm_file,gdo_file,gfn_file,gfm_file,gfp_file,gdk_file,gdl_file,gfs_file ",   # No:FUN-A60053   # No:FUN-B60121  # No:FUN-BB0011   # No:DEV-C40001
        #            "file=exp_dssys.dmp  log=dssys.log "
        #TQC-C70132 -- mark end --
        #TQC-C70132 -- add start --
         LET l_cmd = "cd ",l_topdir CLIPPED,"/pack/",g_tarname CLIPPED,
                     ";exp system/",g_pwd CLIPPED,"@",l_orasid CLIPPED,"  tables=ds.ze_file,ds.zz_file,ds.zm_file,ds.gap_file,ds.gbd_file,ds.gae_file,",
                     "ds.gak_file,ds.gal_file,ds.gaq_file,ds.gab_file,ds.gac_file,ds.gav_file,ds.gat_file,ds.gaz_file,",
                     "ds.wsa_file,ds.wsb_file,ds.zaa_file,ds.zab_file,ds.gao_file,ds.gba_file,ds.gbb_file,ds.gax_file,",
                     "ds.gbf_file,ds.zad_file,ds.zae_file,ds.wca_file,ds.wcb_file,ds.wcc_file,ds.wcd_file,ds.zaw_file,",
                     "ds.zav_file,ds.zai_file,ds.zaj_file,ds.zak_file,ds.zal_file,ds.zam_file,ds.zan_file,ds.zao_file,",
                     "ds.zap_file,ds.zaq_file,ds.zar_file,ds.zas_file,ds.zat_file,ds.zau_file,ds.zay_file,ds.wsm_file,ds.wsn_file,",
                     "ds.wso_file,ds.wsp_file,ds.wsr_file,ds.wss_file,ds.wst_file,ds.wgf_file,",   
                     "ds.pth_file,ds.wsd_file,ds.wse_file,ds.wsf_file,ds.wsg_file,ds.wsh_file,ds.wsi_file,",
                     "ds.wah_file,ds.wai_file,ds.waj_file,ds.waa_file,ds.wab_file,ds.wac_file,ds.wad_file,ds.wae_file,ds.wan_file,ds.gee_file,",
                     "ds.zta_file,ds.wao_file,ds.gdw_file,ds.gdm_file,ds.gdo_file,ds.gfn_file,ds.gfm_file,ds.gfp_file,ds.gdk_file,ds.gdl_file,ds.gfs_file,",
                     "ds.gdr_file,ds.gds_file,ds.gbl_file ",   # No:FUN-D10131
                     " file=exp_dssys.dmp  log=dssys.log "
        #TQC-C70132 -- add end --                                 
         RUN l_cmd

        #TQC-C70132 -- mark start --
        ## No:FUN-C20069 ---start---
        #LET l_cmd = "cd ",l_topdir CLIPPED,"/pack/",g_tarname CLIPPED,
        #            ";exp wds/wds@",l_orasid CLIPPED,
        #            " tables=wzb_file,wzc_file,wzd_file,wzf_file,wzh_file,wzi_file,wzl_file,",   # No:FUN-C20069
        #            " wzm_file,wzo_file,wzs_file,wzz_file,wya_file,wyb_file,wyc_file ",   # No:FUN-C20069
        #            " file=exp_wdssys.dmp  log=wdssys.log "
        #TQC-C70132 -- mark end --
        #TQC-C70132 -- add start --
         LET l_cmd = "cd ",l_topdir CLIPPED,"/pack/",g_tarname CLIPPED,
                     ";exp system/",g_pwd CLIPPED,"@",l_orasid CLIPPED,"  tables=wds.wzb_file,wds.wzc_file,wds.wzd_file,wds.wzf_file,wds.wzh_file,wds.wzi_file,wds.wzl_file,",
                     " wds.wzm_file,wds.wzo_file,wds.wzs_file,wds.wzz_file,wds.wya_file,wds.wyb_file,wds.wyc_file ",
                     " file=exp_wdssys.dmp  log=wdssys.log "
        #TQC-C70132 -- add end --
         RUN l_cmd
         # No:FUN-C20069 --- end ---
      END IF
   END IF     
           
   #cut lang 1
   SELECT COUNT(*) INTO l_i  FROM gay_file WHERE gay01 = '1'  #TQC-7A0016
 
   # 刪除語言別為英文的資料
   IF l_i = 0 THEN
      DELETE  FROM  patchtemp.ze_file   WHERE  ze02  = '1'
      DELETE  FROM  patchtemp.gbd_file  WHERE  gbd03 = '1'
      DELETE  FROM  patchtemp.gae_file  WHERE  gae03 = '1'
      DELETE  FROM  patchtemp.gaq_file  WHERE  gaq02 = '1'
      DELETE  FROM  patchtemp.gat_file  WHERE  gat02 = '1'
      DELETE  FROM  patchtemp.gaz_file  WHERE  gaz02 = '1'
      DELETE  FROM  patchtemp.zaa_file  WHERE  zaa03 = '1'
      DELETE  FROM  patchtemp.zab_file  WHERE  zab04 = '1'
      DELETE  FROM  patchtemp.gba_file  WHERE  gba04 = '1'
      DELETE  FROM  patchtemp.gbb_file  WHERE  gbb04 = '1'
      DELETE  FROM  patchtemp.gbf_file  WHERE  gbf02 = '1'
      DELETE  FROM  patchtemp.zad_file  WHERE  zad03 = '1'
      DELETE  FROM  patchtemp.zae_file  WHERE  zae05 = '1'
      DELETE  FROM  patchtemp.zaw_file  WHERE  zaw06 = '1'
      DELETE  FROM  patchtemp.zal_file  WHERE  zal03 = '1'
      DELETE  FROM  patchtemp.wan_file  WHERE  wan05 = '1'   # No:FUN-960050
      DELETE  FROM  patchtemp.gee_file  WHERE  gee03 = '1'   # No:FUN-A30105
   #  DELETE  FROM  patchtemp.zta_file  WHERE  zta01 = '1'   # No:FUN-A60053
      DELETE  FROM  patchtemp.gdm_file  WHERE  gdm03 = '1'   # No:FUN-B60121
      DELETE  FROM  patchtemp.gfs_file  WHERE  gfs02 = '1'   # No:DEV-C40001
      DELETE  FROM  patchtemp.gfp_file  WHERE  gfp03 = '1'   # No:FUN-BB0011
      DELETE  FROM  patchtemp.wzm_file  WHERE  wzm07 = '1'   # No:FUN-C20069
      DELETE  FROM  patchtemp.wzh_file  WHERE  wzh02 = '1'   # No:FUN-C20069
      DELETE  FROM  patchtemp.wzf_file  WHERE  wzf03 = '1'   # No:FUN-C20069
      DELETE  FROM  patchtemp.wya_file  WHERE  wya03 = '1'   # No:FUN-C20069
      DELETE  FROM  patchtemp.gds_file  WHERE  gds02 = '1'   # No:FUN-CB0095
   END IF     
 
   #080625 by flowld
   LET l_ac = 1 
   CALL tm.clear()
   LET l_sql = "SELECT 'N','','',pzl05,pzl09,pzl01,pzl08,pzl00,pzl45,pzl15,pzl06 ",
               " FROM patchtemp.pzl_file"
            #  " WHERE trim(patchno) ='",g_a_t,"'"
       
   PREPARE pzl_prepare FROM l_sql
   DECLARE pzl_curs CURSOR FOR pzl_prepare
   FOREACH pzl_curs INTO tm[l_ac].*  
      IF SQLCA.sqlcode != 0 THEN
         EXIT FOREACH
      END IF
       
      LET tm[l_ac].row = l_ac
      LET l_ac =l_ac + 1
   END FOREACH
   CALL tm.deleteElement(l_ac)
 
  #LET g_rec_b = l_ac -1
  #DISPLAY g_rec_b TO FORMONLY.cn2
  #DISPLAY l_a     TO FORMONLY.a
 
   FOR l_ac = 1 TO tm.getlength()
      SELECT COUNT(*) INTO l_cnt FROM pth_file
       WHERE pth01 = tm[l_ac].zl08
  
      IF SQLCA.sqlcode != 0 THEN
         EXIT FOR
      END IF  
      IF l_cnt = 0 THEN
         LET tm[l_ac].alter = 'N'
      ELSE
         LET tm[l_ac].alter = 'Y'
      END IF
   END FOR
 
   WHILE TRUE
      #TQC-870008
      FOR l_i = 1 TO tm.getlength()
         LET tm[l_i].select='Y'
      END FOR
      #TQC-870008
 
      #FUN-860102
      IF NOT cl_null(g_argv1) THEN 
         LET g_quit = 'N'
         EXIT WHILE 
      END IF    
      #FUN-860102
 
      LET g_rec_b = 0
     # TQC-BB0216 -- mark start --
     #INPUT ARRAY tm WITHOUT DEFAULTS FROM s_no.*
     #   ATTRIBUTE(COUNT=g_rec_b,
     #             MAXCOUNT=tm.getLength(),UNBUFFERED,    # No:FUN-A90064
     #             INSERT ROW=FALSE,
     #             DELETE ROW=FALSE,
     #             APPEND ROW=FALSE)
 
     #   BEFORE INPUT
     #      IF g_rec_b != 0 THEN
     #         CALL fgl_set_arr_curr(l_ac)
     #      END IF
     #   
     #   BEFORE ROW
     #      LET l_ac = ARR_CURR()
     #      IF l_ac > 0 THEN
     #         DISPLAY tm[l_ac].zl15 TO zl15_detail
     #         DISPLAY tm[l_ac].zl06 TO zl06_detail
     #      END IF
     #
     #      SELECT pzl27 INTO l_zl27 FROM patchtemp.pzl_file WHERE pzl08= tm[l_ac].zl08
     #      IF l_zl27 = 'Y' THEN 
     #         ERROR "該單標記為‘重大異常’,請仔細查看‘更新摘要’！"
     #      END IF   
     #
     #   ON ACTION update_curr
     #      CALL g_show_msg_curr.clear()
     #      LET l_ac = ARR_CURR()
     #      IF NOT INT_FLAG AND tm[l_ac].zl09 IS NOT NULL AND
     #         (tm[l_ac].zl08 IS NOT NULL OR tm[l_ac].zl00 IS NOT NULL) THEN
     #         CALL update_list(tm[l_ac].zl08)
     #         CALL cust_show()
     #
     #         CALL cl_show_array(base.TypeInfo.create(g_show_msg_curr),'GP修改/資料同步清單,請自行轉存excel存檔','已客制否|單號|動作|程式或資料|KEY值欄位1|KEY值欄位2|備註1|模組|系統別|備註2')
     #         IF INT_FLAG = 1 THEN
     #            LET INT_FLAG = 0
     #         END IF
     #      END IF            
     #
     #   ON ACTION alter_curr
     #      CALL g_show_alter_list.clear()    
     #      LET l_ac = ARR_CURR()
     #      IF tm[l_ac].zl45 = 'Y' THEN
     #         IF NOT INT_FLAG AND tm[l_ac].zl09 IS NOT NULL AND
     #            (tm[l_ac].zl08 IS NOT NULL OR tm[l_ac].zl00 IS NOT NULL) THEN
     #            CALL s_get_alter_list(tm[l_ac].zl08)
     #         END IF
     #      END IF
     #
     #      CALL cl_show_array(base.TypeInfo.create(g_show_alter_list),'Alter Table清單請自行轉存excel存檔','檔案編號|資料庫別|修正指令及說明|程序單號|修改日期|修改序號')   # No.FUN-950103 add 資料庫別
     #      IF INT_FLAG = 1 THEN
     #         LET INT_FLAG = 0
     #      END IF
     #
     #   ON ACTION update_list
     #      CALL g_show_msg_curr.clear() 
     #      FOR l_ac = 1 TO tm.getlength()
     #         IF tm[l_ac].select = 'Y' THEN
     #            CALL update_list(tm[l_ac].zl08)    
     #         END IF
     #      END FOR         
     #      CALL cust_show()
     #
     #      CALL cl_show_array(base.TypeInfo.create(g_show_msg_curr),'GP修改/資料同步清單,請自行轉存excel存檔','已客制否|單號|動作|程式或資料|KEY值欄位1|KEY值欄位2|備註1|模組別|系統別|備註2')      
     #      IF INT_FLAG = 1 THEN
     #         LET INT_FLAG = 0
     #      END IF
     #
     #   ON ACTION alter_list
     #      CALL g_show_alter_list.clear()
     #      FOR l_ac = 1 TO tm.getlength()
     #         IF tm[l_ac].select = 'Y' AND tm[l_ac].zl45 = 'Y' THEN
     #            CALL s_get_alter_list(tm[l_ac].zl08)
     #         END IF
     #      END FOR
     #
     #      CALL cl_show_array(base.TypeInfo.create(g_show_alter_list),'Alter Table清單請自行轉存excel存檔','檔案編號|資料庫別|修正指令及說明|程序單號|修改日期|修改序號')   # No.FUN-950103 add 資料庫別
     #      IF INT_FLAG = 1 THEN
     #         LET INT_FLAG = 0
     #      END IF
     #
     #   ON ACTION cancel                 
     #      CLEAR FORM  
     #      RETURN
     #  
     #   ON ACTION comp_link                                                                                                          
     #      IF g_link = "Y" THEN                                                                                                       
     #         LET g_link = "N"                                                                                                         
     #      ELSE                                                                                                                       
     #         LET g_link = "Y"                                                                                                         
     #      END IF                                                                                                                     
     #      DISPLAY g_link TO FORMONLY.b     
     #
     #   #TQC-860017 start
     #   ON ACTION about
     #      CALL cl_about()
     #
     #   ON ACTION controlg
     #      CALL cl_cmdask()
     #
     #   ON ACTION help
     #      CALL cl_show_help()
     #
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE INPUT
     #   #TQC-860017 end
     #END INPUT
 
      CALL g_show_alter_list.clear()                                                                                             
      FOR l_ac = 1 TO tm.getlength()                                                                                             
         IF tm[l_ac].select = 'Y' AND tm[l_ac].zl45 = 'Y' THEN                                                                   
            CALL s_get_alter_list(tm[l_ac].zl08)                                                                                              
         END IF                                                                                                                  
      END FOR
 
      IF g_show_alter_list.getLength() != 0 THEN
        #LET l_title ="重要信息"
        #LET l_cont ="1.此包需要首先變更您的數據庫表結構！\n",
        #            "2.請在變更表結構前首先備份原表！\n", 
        #            "3.需在系統停機狀態下才可變更表結構！\n",
        #            "4.注意非DS庫的表是否需要變更！\n",
        #            "5.退出，將彈出ALTER TABLE清單！\n",
        #            "6.繼續，將會把此包PATCH您的系統！\n"
 
        #MENU l_title ATTRIBUTE (STYLE="dialog",COMMENT=l_cont CLIPPED, IMAGE="information")                                             
        #                                                                                                                         
        #   ON ACTION  CONTINUE                                                                                                                 
               LET g_quit = "N"
        #      EXIT MENU                                                                                                                    
                                                                                                                                  
        #   ON ACTION  quit 
        #      LET g_quit = "Y"                                                                                                              
        #      EXIT MENU  
        #                                                                                                                           
        #   #TQC-860017 start
        #   ON IDLE g_idle_seconds
        #      CALL cl_on_idle()
        #      CONTINUE MENU
        #   #TQC-860017 end
 
        #END MENU
 
         IF INT_FLAG = 1 THEN
            LET INT_FLAG = 0
         END IF
           
         LET g_max_rec_o = g_max_rec    #CHI-8C0021
        #LET g_max_rec   = 3000         #CHI-8C0021 
         LET g_max_rec   = g_show_alter_list.getLength()         # No:FUN-A90064
        #CALL cl_show_array(base.TypeInfo.create(g_show_alter_list),'Alter Table清單請自行轉存excel存檔,并根據清單調整表結構。','檔案編號|資料庫別|修正指令及說明|程序單號|修改日期|修改序號')   # No.FUN-950103 add 資料庫別
         CALL p_unpack2_show_array(base.TypeInfo.create(g_show_alter_list),'Alter Table清單請自行轉存excel存檔,并根據清單調整表結構。','檔案編號|資料庫別|修正指令及說明|程序單號|修改日期|修改序號')   # No.FUN-950103 add 資料庫別
         CALL os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)) RETURNING ls_cnt   #TQC-C30059 add
         IF ls_cnt THEN  #TQC-C30059 表示有找到
         LET l_cmd = "mv ",os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_list.xls")
         RUN l_cmd
         END IF    #TQC-C30059
         LET g_max_rec   = g_max_rec_o  #CHI-8C0021
        #IF INT_FLAG = 1 THEN
        #   LET INT_FLAG = 0
        #END IF
 
        #IF g_quit = 'N' THEN
        #   LET l_title ="請確認"
        #   LET l_cont  ="請確認是否已經變更數據庫表結構！\n",
        #                "退出，查看'alter table清單'，更新表結構！\n",
        #                "繼續，請確認表結構已更新，點此按鈕繼續作業！"
 
        #   MENU l_title ATTRIBUTE (STYLE="dialog",COMMENT=l_cont CLIPPED, IMAGE="information")                                             
        #                                                                                                                           
        #      ON ACTION CONTINUE                                                                                                                  
        #         LET g_quit = "N"
        #         EXIT MENU                                                                                                                    
        #                                                                                                                            
        #      ON ACTION quit
        #         LET g_quit = "Y"                                                                                                              
        #         EXIT MENU  
        #                                                                                                                           
        #      #TQC-860017 start
        #      ON IDLE g_idle_seconds
        #         CALL cl_on_idle()
        #         CONTINUE MENU
        #      #TQC-860017 end
        #   END MENU
 
        #   IF INT_FLAG = 1 THEN
        #      LET INT_FLAG = 0
        #   END IF
            IF g_quit = 'N' THEN 
               EXIT WHILE 
            END IF              
        #END IF   
      ELSE 
         LET g_quit = 'N'
         EXIT WHILE 
      END IF 	                  
   END WHILE
 
   IF g_quit = "N" THEN
      CALL alter_database()     
   END IF 
   IF g_quit = 'N' THEN
      CALL tar_source()
      #記錄上PATCH信息檔pth_file
      SELECT DISTINCT(patchno) INTO  l_pthno FROM patchtemp.pzl_file
 
      LET l_date = TODAY
      LET l_time = TIME
      LET l_tarnm = g_tarname CLIPPED,".tar"
      LET l_tarname = l_tarnm CLIPPED
      LET l_row = l_tarnm.getIndexOf("-",1)
      FOR l_i = 1 TO tm.getLength()
         IF tm[l_i].select = 'Y'  THEN
            INSERT INTO pth_file VALUES(tm[l_i].zl08,tm[l_i].zl09,l_date,g_user,l_time,l_pthno,l_tarname)
            IF SQLCA.sqlcode THEN
               CONTINUE FOR 
            END IF
         END IF
      END FOR
   ELSE
      DISPLAY "重要說明："
      DISPLAY "1.請在變更表結構前首先備份原表！" 
      DISPLAY "2.需在系統停機狀態下才可變更表結構！"
      DISPLAY "3.注意非DS庫的表是否需要變更！"
      DISPLAY "4.如果點選“繼續”按鈕仍出現此訊息，請查看您選擇的單號是否已經PATCH到系統！"
   END IF 
   CLEAR FORM 
END FUNCTION
 
 
FUNCTION update_list(p_zl08)
   DEFINE   p_zl08         LIKE type_file.chr30
   DEFINE   l_dir1         LIKE type_file.chr6
   DEFINE   l_dir2         LIKE type_file.chr6
   DEFINE   l_cnt          LIKE type_file.num10
   DEFINE   l_sql          STRING
   DEFINE   l_cmd          LIKE type_file.chr1000 
   DEFINE   l_i            LIKE type_file.num5
  
   LET g_envcust =FGL_GETENV('CUST')
   
   LET l_sql = " SELECT '',pyc01,pyc03,pyc05,pyc06,pyc07,pyc08,zln03,zln04,gaz03 ",   # No:FUN-C20069   # No:FUN-C20108
               "   FROM patchtemp.pyc_file",
               "  WHERE pyc01 = '",p_zl08 CLIPPED,"'",
               "    AND pack = 'Y' ",
               " ORDER BY pyc05 " 

   PREPARE pyc_prepare FROM l_sql
   DECLARE pyc_curs CURSOR FOR pyc_prepare

   LET g_cnt = g_show_msg_curr.getLength() + 1   # No:FUN-C20069

   FOREACH pyc_curs INTO g_show_msg_curr[g_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
           
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_show_msg_curr.deleteElement(g_cnt)
END FUNCTION
 
 
FUNCTION cust_show()
   DEFINE   l_dir1         LIKE type_file.chr6
   DEFINE   l_dir2         LIKE type_file.chr6
   DEFINE   l_cnt          LIKE type_file.num10
   DEFINE   l_sql          STRING
   DEFINE   l_cmd          LIKE type_file.chr1000 
   DEFINE   l_i            LIKE type_file.num5
  
   FOR l_cnt = 1 TO g_show_msg_curr.getlength()
      # No:FUN-C20069 --- modify start---
      IF g_show_msg_curr[l_cnt].syc05 = '程式' AND g_show_msg_curr[l_cnt].zln03 NOT MATCHES 'w*' THEN   # No:FUN-C20069
      #  SELECT unique(pnl03),pnl04 INTO l_dir1,l_dir2 FROM patchtemp.pyc_file 
      #   WHERE pyc06 = g_show_msg_curr[l_cnt].syc06
          
         IF g_show_msg_curr[l_cnt].zln03 CLIPPED = "top" THEN
            LET g_show_msg_curr[l_cnt].cust = 'N'
         ELSE
            IF (g_show_msg_curr[l_cnt].zln03 CLIPPED="lib") OR (g_show_msg_curr[l_cnt].zln03 CLIPPED="sub")
               OR (g_show_msg_curr[l_cnt].zln03 CLIPPED="qry") OR (g_show_msg_curr[l_cnt].zln03 MATCHES "g*") THEN
 
               LET l_dir1 = "c",g_show_msg_curr[l_cnt].zln03
            ELSE
 
               LET l_dir1  = g_show_msg_curr[l_cnt].zln03[2,6]
               LET l_dir1 = "c",l_dir1 CLIPPED
            END IF

            # No:FUN-A90064 ---start---
            LET l_cmd = os.Path.join(os.Path.join(os.Path.join(g_envcust,l_dir1),g_show_msg_curr[l_cnt].zln04),g_show_msg_curr[l_cnt].syc06)
            CALL os.Path.exists(l_cmd) RETURNING l_i
            # No:FUN-A90064 --- end ---

            IF l_i THEN
               LET g_show_msg_curr[l_cnt].cust = 'Y'
            ELSE
               LET g_show_msg_curr[l_cnt].cust ='N'
            END IF      
         END IF
      END IF
      # No:FUN-C20069 --- modify end ---
   END FOR                 
 
   FOR l_cnt = 1 TO g_show_msg_curr.getlength()
      IF g_show_msg_curr[l_cnt].syc05 != '程式' THEN
         CASE
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gbd_file")
               SELECT COUNT(*) INTO l_i FROM gbd_file 
                WHERE gbd01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND gbd07 = 'Y'
               IF l_i <= 0 THEN
                  LET g_show_msg_curr[l_cnt].cust='N'
               ELSE
                  LET g_show_msg_curr[l_cnt].cust='Y'
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gaz_file")
               SELECT COUNT(*) INTO l_i FROM gaz_file
                WHERE gaz01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND gaz05 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gae_file")
               SELECT COUNT(*) INTO l_i FROM gae_file
                WHERE gae01 = g_show_msg_curr[l_cnt].syc06 # CLIPPED
                  AND  gae11 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gal_file")
               SELECT COUNT(*) INTO l_i FROM gal_file
                WHERE gal01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND  gal04 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gab_file")
               SELECT COUNT(*) INTO l_i FROM gab_file
                WHERE gab01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND gab11 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gac_file")
               SELECT COUNT(*) INTO l_i FROM gac_file
                WHERE gac01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND gac12 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gar_file")
               SELECT COUNT(*) INTO l_i FROM gar_file
                WHERE gar01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND  gar08 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "zaa_file")
               SELECT COUNT(*) INTO l_i FROM zaa_file
                WHERE zaa01= g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND zaa10 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "zaw_file")
               SELECT COUNT(*) INTO l_i FROM zaw_file
                WHERE zaw01= g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND zaw03 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF                
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "gax_file")
               SELECT COUNT(*) INTO l_i FROM gax_file
                WHERE gax01 = g_show_msg_curr[l_cnt].syc06 #CLIPPED
                  AND gax05 = 'Y'
               IF l_i <= 0 THEN                                                                                                    
                  LET g_show_msg_curr[l_cnt].cust='N'                                                                              
               ELSE                                                                                                                
                  LET g_show_msg_curr[l_cnt].cust='Y'                                                                              
               END IF
            WHEN(g_show_msg_curr[l_cnt].syc05 CLIPPED = "zai_file")
               SELECT COUNT(*) INTO l_i FROM zai_file
                WHERE zai01 = g_show_msg_curr[l_cnt].syc06
                  AND zai05 = 'Y'
               IF l_i <= 0 THEN 
                  LET g_show_msg_curr[l_cnt].cust='N'
               ELSE 
                  LET g_show_msg_curr[l_cnt].cust='Y'
               END IF    	        
            OTHERWISE
               LET g_show_msg_curr[l_cnt].cust='N'
         END CASE 
      END IF        
   END FOR
END FUNCTION
 
 
FUNCTION s_get_alter_list(p_zl08)
   DEFINE   p_zl08         LIKE type_file.chr30
   DEFINE   l_cnt          LIKE type_file.num10                                                                                                   
   DEFINE   l_sql          STRING
 
   LET l_sql = "SELECT pzs01,pzsdb,pzs06,pzs08,pzs04,pzs03 FROM patchtemp.pzs_file",   # No.FUN-950103 add pzsdb
               " WHERE pzs08 = '",p_zl08 CLIPPED,"'",
               " ORDER BY pzs04,pzs03,pzs01 "

   PREPARE pzs_prepare FROM l_sql
   DECLARE pzs_curs CURSOR FOR pzs_prepare

   LET g_cnt = g_show_alter_list.getLength() + 1   # No:FUN-C20069

   FOREACH pzs_curs INTO g_show_alter_list[g_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_show_alter_list.deleteElement(g_cnt)
END FUNCTION
 
 
FUNCTION alter_database()
   DEFINE  l_channel  base.Channel
   DEFINE  l_cmd      STRING
   DEFINE  l_str      STRING      
   DEFINE  l_i        LIKE type_file.num5
   DEFINE  alter      DYNAMIC ARRAY OF RECORD
                      plant   LIKE type_file.chr30,
                      user    LIKE type_file.chr30,
                      pwd     LIKE type_file.chr30
                      END RECORD 
   DEFINE  l_ds       DYNAMIC ARRAY OF LIKE type_file.chr20
   DEFINE  l_plant_t  LIKE type_file.chr10
   DEFINE  l_rec_b    LIKE type_file.num5
   DEFINE  l_ac       LIKE type_file.num5
   DEFINE  l_tempdir  STRING
   DEFINE  l_topdir   STRING
   DEFINE  l_title    STRING
   DEFINE  l_cont     STRING
   DEFINE  l_k        LIKE type_file.num5    # No:FUN-A90064
   DEFINE  l_tarname  STRING                 # No:FUN-A90064
   DEFINE  l_file     STRING                 # No:FUN-A90064

 
   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET l_topdir  = FGL_GETENV('TOP')
   LET l_tarname = os.Path.join(os.Path.join(FGL_GETENV('TOP'),"pack"),g_tarname)   # No:FUN-A90064
 
   CALL g_show_msg_curr.clear()                                                                                              
   FOR l_ac = 1 TO tm.getlength()                                                                                           
      IF tm[l_ac].select = 'Y'  THEN                                                                                          
         CALL update_list(tm[l_ac].zl08)                                                                                                  
      END IF                                                                                                                 
   END FOR
 
   CALL cust_show()
   IF g_show_msg_curr.getLength() != 0 THEN
      # No:FUN-A90064 ---start---
      LET l_file = os.Path.join(l_tarname,"delete.log")
      CALL os.Path.exists(l_file) RETURNING l_i
      IF l_i THEN
         CALL os.Path.delete(l_file) RETURNING l_k
         IF NOT l_k THEN
            DISPLAY "DELETE ",l_file," FAILD"
         END IF
      END IF

      LET l_channel = base.Channel.create()
      CALL l_channel.openFile(l_file,"w")
      CALL l_channel.setDelimiter("")
      # No:FUN-A90064 --- end ---

      FOR l_i = 1 TO g_show_msg_curr.getlength()       
         IF g_show_msg_curr[l_i].syc05 != "程式" THEN
            IF g_show_msg_curr[l_i].syc03 = "OVERWRITE" THEN 
               INSERT INTO patchtemp.psl_file VALUES(g_show_msg_curr[l_i].syc05,g_show_msg_curr[l_i].syc06,
                                                     g_show_msg_curr[l_i].syc07)
            ELSE
               # No:FUN-A90064 ---start---
               LET l_str = "DELETE FROM ",g_show_msg_curr[l_i].syc05 CLIPPED,
                           " WHERE KEY01='",g_show_msg_curr[l_i].syc06 CLIPPED,"'",
                             " AND KEY02 ='",g_show_msg_curr[l_i].syc07 CLIPPED,"'"
               CALL l_channel.write(l_str)
               # No:FUN-A90064 --- end ---
            END IF     	                            
         END IF
      END FOR
      CALL l_channel.close()    # No:FUN-A90064
      CALL db_update()
      LET g_quit ='N'
   ELSE
      DISPLAY "沒有抓到資料，請檢查單號對應的清單，也可能是所選的單號已經上過PATCH。"
      LET g_quit = 'Y'              
   END IF
END FUNCTION
 
 
FUNCTION db_update()
   DEFINE   p_ver        LIKE type_file.chr3
   DEFINE   l_cmd        STRING
   DEFINE   l_result     LIKE type_file.num5
   DEFINE   lc_channel   base.Channel
#  DEFINE   gc_channel   base.Channel   #TQC-C50150 mark
   DEFINE   l_str        STRING
   DEFINE   lr_ze        RECORD LIKE ze_file.*
   DEFINE   lr_zz        RECORD LIKE zz_file.*
   DEFINE   lr_zm        RECORD LIKE zm_file.*
   DEFINE   lr_gap       RECORD LIKE gap_file.*
   DEFINE   lr_gbd       RECORD LIKE gbd_file.*
   DEFINE   lr_gae       RECORD LIKE gae_file.*
   DEFINE   lr_gak       RECORD LIKE gak_file.*
   DEFINE   lr_gal       RECORD LIKE gal_file.*
   DEFINE   lr_gaq       RECORD LIKE gaq_file.*
   DEFINE   lr_gab       RECORD LIKE gab_file.*
   DEFINE   lr_gac       RECORD LIKE gac_file.*
   DEFINE   lr_gav       RECORD LIKE gav_file.*
   DEFINE   lr_gat       RECORD LIKE gat_file.*
   DEFINE   lr_gaz       RECORD LIKE gaz_file.*
   DEFINE   lr_wsa       RECORD LIKE wsa_file.*
   DEFINE   lr_wsb       RECORD LIKE wsb_file.*
   DEFINE   lr_zaa       RECORD LIKE zaa_file.*
   DEFINE   lr_zab       RECORD LIKE zab_file.*
   DEFINE   lr_gao       RECORD LIKE gao_file.*
   DEFINE   lr_gax       RECORD LIKE gax_file.*
   DEFINE   lr_gba       RECORD LIKE gba_file.*
   DEFINE   lr_gbb       RECORD LIKE gbb_file.*
   DEFINE   lr_gbf       RECORD LIKE gbf_file.*
   DEFINE   lr_zad       RECORD LIKE zad_file.*
   DEFINE   lr_zae       RECORD LIKE zae_file.*   
   DEFINE   lr_wca       RECORD LIKE wca_file.*
   DEFINE   lr_wcb       RECORD LIKE wcb_file.*
   DEFINE   lr_wcc       RECORD LIKE wcc_file.*
   DEFINE   lr_wcd       RECORD LIKE wcd_file.*
   DEFINE   lr_zaw       RECORD LIKE zaw_file.*
   DEFINE   lr_zav       RECORD LIKE zav_file.*
   DEFINE   lr_zai       RECORD LIKE zai_file.*
   DEFINE   lr_zaj       RECORD LIKE zaj_file.*
   DEFINE   lr_zak       RECORD LIKE zak_file.*
   DEFINE   lr_zal       RECORD LIKE zal_file.*
   DEFINE   lr_zam       RECORD LIKE zam_file.*
   DEFINE   lr_zan       RECORD LIKE zan_file.*
   DEFINE   lr_zao       RECORD LIKE zao_file.*
   DEFINE   lr_zap       RECORD LIKE zap_file.*
   DEFINE   lr_zaq       RECORD LIKE zaq_file.*
   DEFINE   lr_zar       RECORD LIKE zar_file.*
   DEFINE   lr_zas       RECORD LIKE zas_file.*
   DEFINE   lr_zat       RECORD LIKE zat_file.*
   DEFINE   lr_zau       RECORD LIKE zau_file.*
   DEFINE   lr_zay       RECORD LIKE zay_file.*
   DEFINE   lr_wsm       RECORD LIKE wsm_file.*
   DEFINE   lr_wsn       RECORD LIKE wsn_file.*
   DEFINE   lr_wso       RECORD LIKE wso_file.*
   DEFINE   lr_wsp       RECORD LIKE wsp_file.*
   #FUN-8A0115 -add -start
   DEFINE   lr_wsr       RECORD LIKE wsr_file.*
   DEFINE   lr_wss       RECORD LIKE wss_file.*
   DEFINE   lr_wst       RECORD LIKE wst_file.*
   DEFINE   lr_wgf       RECORD LIKE wgf_file.*
   #FUN-8A0115--end
   #No.FUN-8C0005 --start--
   DEFINE   lr_wsd       RECORD LIKE wsd_file.*
   DEFINE   lr_wse       RECORD LIKE wse_file.*
   DEFINE   lr_wsf       RECORD LIKE wsf_file.*
   DEFINE   lr_wsg       RECORD LIKE wsg_file.*
   DEFINE   lr_wsh       RECORD LIKE wsh_file.*
   DEFINE   lr_wsi       RECORD LIKE wsi_file.*
   #No.FUN-8C0005 ---end---
   #No.FUN-8C0067 --start--
   DEFINE   lr_wah       RECORD LIKE wah_file.*
   DEFINE   lr_wai       RECORD LIKE wai_file.*
   DEFINE   lr_waj       RECORD LIKE waj_file.*
   DEFINE   lr_waa       RECORD LIKE waa_file.*
   DEFINE   lr_wab       RECORD LIKE wab_file.*
   DEFINE   lr_wac       RECORD LIKE wac_file.*
   #No.FUN-8C0067 ---end---
   # No.FUN-960050 ---start---
   DEFINE   lr_wad       RECORD LIKE wad_file.*
   DEFINE   lr_wae       RECORD LIKE wae_file.*
   DEFINE   lr_wan       RECORD LIKE wan_file.*
   # No.FUN-960050 --- end ---
   DEFINE   lr_gee       RECORD LIKE gee_file.*    # No:FUN-A30105
   DEFINE   lr_zta       RECORD LIKE zta_file.*    # No:FUN-A60053
   DEFINE   lr_wao       RECORD LIKE wao_file.*    # No:FUN-B60121
   DEFINE   lr_gdw       RECORD LIKE gdw_file.*    # No:FUN-B60121
   DEFINE   lr_gdm       RECORD LIKE gdm_file.*    # No:FUN-B60121
   DEFINE   lr_gfs       RECORD LIKE gfs_file.*    # No:DEV-C40001
   DEFINE   lr_gdo       RECORD LIKE gdo_file.*    # No:FUN-B60121
   DEFINE   lr_gfn       RECORD LIKE gfn_file.*    # No:FUN-BB0011
   DEFINE   lr_gfm       RECORD LIKE gfm_file.*    # No:FUN-BB0011
   DEFINE   lr_gfp       RECORD LIKE gfp_file.*    # No:FUN-BB0011
   DEFINE   lr_gdk       RECORD LIKE gdk_file.*    # No:FUN-BB0011
   DEFINE   lr_gdl       RECORD LIKE gdl_file.*    # No:FUN-BB0011
   DEFINE   lr_gdr       RECORD LIKE gdr_file.*    # No:FUN-CB0095
   DEFINE   lr_gds       RECORD LIKE gds_file.*    # No:FUN-CB0095
   DEFINE   lr_gbl       RECORD LIKE gbl_file.*    # No:FUN-D10131
   DEFINE   lc_zz011     LIKE zz_file.zz011
   DEFINE   lc_gal02     LIKE gal_file.gal02 #TQC-7C0065 add
   DEFINE   ls_zz011     STRING
   DEFINE   l_tempdir    STRING
   DEFINE   l_topdir     STRING
   DEFINE   readfile_channel   base.Channel
   DEFINE   li_count     LIKE type_file.num10      #為了要計算一個table做了幾筆資料
   DEFINE   l_cnt        LIKE type_file.num10      #計算用 #TQC-7C0065 add
   DEFINE   l_zm03_max	 LIKE type_file.num10	   #紀錄zm_fil3的zm03最大值 #TQC-BB0134
   DEFINE   lc_gal04     LIKE gal_file.gal04       #TQC-8A0012 add
   DEFINE   l_sql        STRING                    # No:FUN-C20069 
   DEFINE   l_cnt2       LIKE type_file.num10

#  LET g_db_type=DB_GET_DATABASE_TYPE()
   LET l_result = TRUE   
   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET l_topdir  = FGL_GETENV('TOP')
  #TQC-C50150 -- mark start --
  #LET gc_channel = base.Channel.create()
  #LET l_cmd = os.Path.join(os.Path.join(os.Path.join(l_topdir,"pack"),g_tarname),"load.log")
  #CALL gc_channel.openFile(l_cmd,"w")
  #CALL gc_channel.setDelimiter("")
  #TQC-C50150 -- mark end --
 
   DISPLAY "開始更新ze_file資料"
   LET li_count = 0
   DECLARE ze_o_curs CURSOR FOR
    SELECT * FROM patchtemp.ze_file
     WHERE ze01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                     WHERE tbname='ze_file')
   FOREACH ze_o_curs INTO lr_ze.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "ze_file patchtemp FOREACH 資料時產生錯誤，ze資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.ze_file VALUES(lr_ze.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.ze_file SET ze_file.* = lr_ze.*
          WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload ze_file data error:",SQLCA.sqlerrd[2]," ",lr_ze.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "ze_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "ze_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zz_file資料"
   LET li_count = 0
   DECLARE zz_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zz_file
             WHERE (zz01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='zz_file'))
                OR (zz01 IN (SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                              WHERE tbname='wzz_file'))

   FOREACH zz_o_curs INTO lr_zz.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zz_file patchtemp FOREACH 資料時產生錯誤，zz資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zz_file VALUES(lr_zz.*)
      IF SQLCA.sqlcode THEN
         SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_zz.zz01
         LET ls_zz011 = lc_zz011
         IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
            UPDATE ds.zz_file SET zz_file.* = lr_zz.*
             WHERE zz01 = lr_zz.zz01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload zz_file data error:",SQLCA.sqlerrd[2]," ",lr_zz.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET l_cmd = "insert zz_file data error:",SQLCA.sqlcode," ",lr_zz.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zz_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zz_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gaz_file資料"
   LET li_count = 0
   DECLARE gaz_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gaz_file
            WHERE (gaz01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='gaz_file'))  
               OR (gaz01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='zz_file'))               
               OR (gaz01 IN (SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                              WHERE tbname='wzz_file'))               
   FOREACH gaz_o_curs INTO lr_gaz.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gaz_file patchtemp FOREACH 資料時產生錯誤，gaz資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gaz_file VALUES(lr_gaz.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gaz_file SET gaz_file.* = lr_gaz.* 
          WHERE gaz01 = lr_gaz.gaz01 AND gaz02 = lr_gaz.gaz02 AND gaz05 = lr_gaz.gaz05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gaz_file data error:",SQLCA.sqlerrd[2]," ",lr_gaz.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gaz_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gaz_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zm_file資料"
   LET li_count = 0
   LET l_cnt = 0	#TQC-BB0134 add
   LET l_zm03_max = 0	#TQC-BB0134 add

   DECLARE zm_o_curs CURSOR FOR
     SELECT  DISTINCT zm_file.* FROM patchtemp.zm_file,patchtemp.psl_file 
       WHERE  zm01=tbkey01 AND zm03=tbkey02 AND tbname='zm_file'                                                                         
          
   FOREACH zm_o_curs INTO lr_zm.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zm_file patchtemp FOREACH 資料時產生錯誤，zm資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      #---TQC-BB0134 add start----
      SELECT COUNT(*) INTO l_cnt FROM ds.zm_file WHERE zm01 = lr_zm.zm01 AND zm04 = lr_zm.zm04
      IF l_cnt = 0 THEN
         SELECT MAX(zm03) INTO l_zm03_max FROM ds.zm_file WHERE zm01 = lr_zm.zm01
         # TQC-C10004 -- add start --
         IF cl_null(l_zm03_max) THEN
            LET l_zm03_max = 0
            SELECT COUNT(*) INTO l_cnt2 FROM ds.zz_file WHERE zz01 = lr_zm.zm04
            IF l_cnt2 = 0 THEN
               LET l_str = "程式自動新增zm節點:   zm01: ",lr_zm.zm01,"    zm04: ",lr_zm.zm04,"    但此節點不存在於p_zz,請手動調整."
               CALL gc_channel.write(l_str)
               LET l_result = FALSE
            END IF
         END IF
         #TQC-C10004 -- add end --
         LET lr_zm.zm03 = l_zm03_max +1
      #---TQC-BB0134 add end----
         INSERT INTO ds.zm_file VALUES(lr_zm.*)
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert zm_file data error:",SQLCA.sqlerrd[2],"   SQL: UPDATE zm_file SET",
                     " zm01 = '",lr_zm.zm01,"', zm03 = '",lr_zm.zm03,"', zm04 = '",lr_zm.zm04,"' WHERE ",
                     " zm01 = '",lr_zm.zm01,"' AND zm03 ='",lr_zm.zm03,"';"
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      #TQC-C10004 -- add start --
      ELSE                                                                                                                  
         LET l_str = "This zm_file already exists in database.:   zm01: ",lr_zm.zm01," zm04: ",lr_zm.zm04 ,"  程式沒有執行更新動作."       
         CALL gc_channel.write(l_str)                                                                                      
         LET l_result = FALSE 
      #TQC-C10004 -- add end --                                                                                              
      END IF   #---TQC-BB0134 add
   END FOREACH
   DISPLAY "zm_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zm_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gap_file資料"
   LET li_count = 0
   DECLARE gap_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gap_file
            WHERE (gap01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='gap_file'))
               OR (gap01 IN (SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                              WHERE tbname='wzi_file'))
   FOREACH gap_o_curs INTO lr_gap.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gap_file patchtemp FOREACH 資料時產生錯誤，gap資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gap_file VALUES(lr_gap.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gap_file SET gap_file.* = lr_gap.*
          WHERE gap01 = lr_gap.gap01 AND gap02 = lr_gap.gap02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "insert gap_file data error:",SQLCA.sqlerrd[2]," ",lr_gap.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gap_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gap_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gbd_file資料"
   LET li_count = 0
   DECLARE gbd_o_curs CURSOR FOR
           SELECT gbd_file.* FROM patchtemp.gbd_file,patchtemp.gap_file
            WHERE gap01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gap_file')
              AND gap02 = gbd01
              AND gbd07 = 'N'
            UNION
           SELECT gbd_file.* FROM patchtemp.gbd_file
            WHERE gbd01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gbd_file')
              AND gbd07 = 'N'
          #TQC-8A0077---mod---str---
          #TQC-820020----mod---end---
   FOREACH gbd_o_curs INTO lr_gbd.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gbd_file patchtemp FOREACH 資料時產生錯誤，gbd資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gbd_file VALUES(lr_gbd.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gbd_file SET gbd_file.* = lr_gbd.*
          WHERE gbd01 = lr_gbd.gbd01 AND gbd02 = lr_gbd.gbd02
            AND gbd03 = lr_gbd.gbd03 AND gbd07 = lr_gbd.gbd07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gbd_file data error:",SQLCA.sqlerrd[2]," ",lr_gbd.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gbd_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gbd_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gae_file資料"
   LET li_count = 0
   DECLARE gae_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gae_file
            WHERE gae01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gae_file')
   FOREACH gae_o_curs INTO lr_gae.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gae_file patchtemp FOREACH 資料時產生錯誤，gae資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gae_file VALUES(lr_gae.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gae_file SET gae_file.* = lr_gae.*
          WHERE gae01 = lr_gae.gae01 AND gae02 = lr_gae.gae02
            AND gae03 = lr_gae.gae03 AND gae11 = lr_gae.gae11 AND gae12 = lr_gae.gae12
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gae_file data error:",SQLCA.sqlerrd[2]," ",lr_gae.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gae_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gae_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041


   DISPLAY "開始更新gak_file資料"
   LET li_count = 0
   DECLARE gak_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gak_file
             WHERE (gak01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                               WHERE tbname='gak_file'))
                OR (gak01 IN (SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                               WHERE tbname='wzl_file'))
   FOREACH gak_o_curs INTO lr_gak.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gak_file patchtemp FOREACH 資料時產生錯誤，gak資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gak_file VALUES(lr_gak.*)
      IF SQLCA.sqlcode THEN
         SELECT zz011 INTO lc_zz011 FROM ds.zz_file WHERE zz01 = lr_gak.gak01
         LET ls_zz011 = lc_zz011
         IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" OR        #TQC-810092 mod
            (lr_gak.gak01 = 'sub' OR lr_gak.gak01 = 'qry' OR lr_gak.gak01 = 'lib') THEN #TQC-810092 add 多sub/qry/lib的判斷
            UPDATE ds.gak_file SET gak_file.* = lr_gak.*
             WHERE gak01 = lr_gak.gak01
            IF SQLCA.sqlcode THEN
               LET l_cmd = "upload gak_file data error:",SQLCA.sqlerrd[2]," ",lr_gak.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            ELSE
               LET li_count = li_count + SQLCA.sqlerrd[3]
            END IF
         ELSE
            LET l_cmd = "insert gak_file data error:",SQLCA.sqlcode," ",lr_gak.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gak_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gak_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gal_file資料"
   LET li_count = 0
   DECLARE gal_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gal_file
             WHERE (gal01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                               WHERE tbname='gal_file'))
                OR (gal01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                               WHERE tbname='gak_file'))
                OR (gal01 IN (SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                               WHERE tbname='wzl_file'))
   FOREACH gal_o_curs INTO lr_gal.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gal_file patchtemp FOREACH 資料時產生錯誤，gal資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF
     #TQC-7C0065 add---str--
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ds.gal_file
       WHERE gal01 = lr_gal.gal01 #鏈結檔案
         AND gal03 = lr_gal.gal03 #程式代碼
      IF l_cnt >=1 THEN
         #==>存在相同的程式代碼時
         #TQC-8A0012 --add-start
         DECLARE gal_g2_curs CURSOR FOR  
          SELECT gal02,gal04 FROM ds.gal_file
                       WHERE gal01 = lr_gal.gal01
                         AND gal03 = lr_gal.gal03
         FOREACH gal_g2_curs INTO lc_gal02,lc_gal04
            LET ls_zz011 = lc_gal02 #系統名
            #IF ls_zz011.subString(1,1) != "C" OR ls_zz011.subString(1,3) = "CL_" THEN
            IF ls_zz011.subString(1,1) != "C"  AND lc_gal04='Y' THEN
            #TQC-8A0012--add-end 
               #不為客製==>更新  # 且為正在鏈結的
               UPDATE ds.gal_file SET gal_file.* = lr_gal.*
                WHERE gal01 = lr_gal.gal01 AND gal03 = lr_gal.gal03 AND gal02 = lr_gal.gal02 #TQC-8A0012
               IF SQLCA.sqlcode THEN
                  LET l_cmd = "upload gal_file data error:",SQLCA.sqlerrd[2]," ",lr_gal.*
                  CALL gc_channel.write(l_cmd)
                  LET l_result = FALSE
               ELSE
                  LET li_count = li_count + SQLCA.sqlerrd[3]
               END IF
            ELSE
               #為客製==>不做任何事
               LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
               CALL gc_channel.write(l_cmd)
               LET l_result = FALSE
            END IF
         END FOREACH  #TQC-8A0012
      ELSE
          INSERT INTO ds.gal_file VALUES(lr_gal.*)
          IF SQLCA.sqlcode THEN
              LET l_cmd = "insert gal_file data error:",SQLCA.sqlcode," ",lr_gal.*
              CALL gc_channel.write(l_cmd)
              LET l_result = FALSE
          ELSE
              LET li_count = li_count + SQLCA.sqlerrd[3]
          END IF
      END IF
      #TQC-7C0065 add---end--
   END FOREACH
   DISPLAY "gal_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gal_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gaq_file資料"
   LET li_count = 0
   DECLARE gaq_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gaq_file
            WHERE gaq01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gaq_file')
   FOREACH gaq_o_curs INTO lr_gaq.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gaq_file patchtemp FOREACH 資料時產生錯誤，gaq資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gaq_file VALUES(lr_gaq.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gaq_file SET gaq_file.* = lr_gaq.*
          WHERE gaq01 = lr_gaq.gaq01 AND gaq02 = lr_gaq.gaq02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gaq_file data error:",SQLCA.sqlerrd[2]," ",lr_gaq.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gaq_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gaq_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gab_file資料"
   LET li_count = 0
   DECLARE gab_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gab_file
             WHERE gab01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='gab_file')
   FOREACH gab_o_curs INTO lr_gab.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gab_file patchtemp FOREACH 資料時產生錯誤，gab資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gab_file VALUES(lr_gab.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gab_file SET gab_file.* = lr_gab.*
          WHERE gab01 = lr_gab.gab01 AND gab11 = lr_gab.gab11
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gab_file data error:",SQLCA.sqlerrd[2]," ",lr_gab.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gab_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gab_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gac_file資料"
   LET li_count = 0
   DECLARE gac_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gac_file
            WHERE gac01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gac_file')  
               OR gac01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gab_file')              
   FOREACH gac_o_curs INTO lr_gac.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gac_file patchtemp FOREACH 資料時產生錯誤，gac資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gac_file VALUES(lr_gac.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gac_file SET gac_file.* = lr_gac.*
          WHERE gac01 = lr_gac.gac01 AND gac02 = lr_gac.gac02
            AND gac03 = lr_gac.gac03 AND gac12 = lr_gac.gac12
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gac_file data error:",SQLCA.sqlerrd[2]," ",lr_gac.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gac_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gac_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gav_file資料"
   LET li_count = 0
   DECLARE gav_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gav_file
             WHERE gav01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='gav_file') 
   FOREACH gav_o_curs INTO lr_gav.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gav_file patchtemp FOREACH 資料時產生錯誤，gav資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gav_file VALUES(lr_gav.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gav_file SET gav_file.* = lr_gav.*
          WHERE gav01 = lr_gav.gav01 AND gav02 = lr_gav.gav02
            AND gav08 = lr_gav.gav08 AND gav11 = lr_gav.gav11
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gav_file data error:",SQLCA.sqlerrd[2]," ",lr_gav.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gav_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gav_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gat_file資料"
   LET li_count = 0
   DECLARE gat_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gat_file
            WHERE gat01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gat_file')   
   FOREACH gat_o_curs INTO lr_gat.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gat_file patchtemp FOREACH 資料時產生錯誤，gat資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gat_file VALUES(lr_gat.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gat_file SET gat_file.* = lr_gat.*
          WHERE gat01 = lr_gat.gat01 AND gat02 = lr_gat.gat02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gat_file data error:",SQLCA.sqlerrd[2]," ",lr_gat.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gat_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gat_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsa_file資料"
   LET li_count = 0
   DECLARE wsa_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsa_file
             WHERE wsa01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='wsa_file') 
   FOREACH wsa_o_curs INTO lr_wsa.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsa_file patchtemp FOREACH 資料時產生錯誤，wsa資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsa_file VALUES(lr_wsa.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsa_file SET wsa_file.* = lr_wsa.*
          WHERE wsa01 = lr_wsa.wsa01 
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsa_file data error:",SQLCA.sqlerrd[2]," ",lr_wsa.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsa_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsa_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsb_file資料"
   LET li_count = 0
   DECLARE wsb_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsb_file
            WHERE wsb01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                            WHERE tbname='wsb_file')
               OR wsb01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')               
   FOREACH wsb_o_curs INTO lr_wsb.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsb_file patchtemp FOREACH 資料時產生錯誤，wsb資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsb_file VALUES(lr_wsb.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsb_file SET wsb_file.* = lr_wsb.*
          WHERE wsb01 = lr_wsb.wsb01 AND wsb02 = lr_wsb.wsb02
            AND wsb03 = lr_wsb.wsb03
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsb_file data error:",SQLCA.sqlerrd[2]," ",lr_wsb.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsb_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsb_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zaa_file資料"
   LET li_count = 0
   DECLARE zaa_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zaa_file
            WHERE zaa01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='zaa_file')   
   FOREACH zaa_o_curs INTO lr_zaa.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zaa_file patchtemp FOREACH 資料時產生錯誤，zaa資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zaa_file VALUES(lr_zaa.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zaa_file SET zaa_file.* = lr_zaa.*
          WHERE zaa01 = lr_zaa.zaa01 AND zaa02 = lr_zaa.zaa02
            AND zaa03 = lr_zaa.zaa03 AND zaa04 = lr_zaa.zaa04
            AND zaa10 = lr_zaa.zaa10 AND zaa11 = lr_zaa.zaa11
            AND zaa17 = lr_zaa.zaa17
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zaa_file data error:",SQLCA.sqlerrd[2]," ",lr_zaa.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zaa_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zaa_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zab_file資料"
   LET li_count = 0
   DECLARE zab_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zab_file
   FOREACH zab_o_curs INTO lr_zab.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zab_file patchtemp FOREACH 資料時產生錯誤，zab資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zab_file VALUES(lr_zab.*)
      IF SQLCA.sqlcode THEN
         LET l_cmd = "insert zab_file data error:",SQLCA.sqlerrd[2]," ",lr_zab.*
         CALL gc_channel.write(l_cmd)
         LET l_result = FALSE
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zab_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zab_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gao_file資料"
   LET li_count = 0
   DECLARE gao_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gao_file
             WHERE (gao01 IN(SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='gao_file'))
                OR (gao01 IN(SELECT tbkey01 FROM patchtemp.psl_file   # No:FUN-C20069
                              WHERE tbname='wzo_file'))
   FOREACH gao_o_curs INTO lr_gao.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gao_file patchtemp FOREACH 資料時產生錯誤，gao資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gao_file VALUES(lr_gao.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gao_file SET gao_file.* = lr_gao.*
          WHERE gao01 = lr_gao.gao01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gao_file data error:",SQLCA.sqlerrd[2]," ",lr_gao.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gao_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gao_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gax_file資料"
   LET li_count = 0
   DECLARE gax_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gax_file
            WHERE gax01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gax_file')
   FOREACH gax_o_curs INTO lr_gax.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gax_file patchtemp FOREACH 資料時產生錯誤，gax資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gax_file VALUES(lr_gax.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gax_file SET gax_file.* = lr_gax.*
          WHERE gax01 = lr_gax.gax01 AND gax02 = lr_gax.gax02
            AND gax05 = lr_gax.gax05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gax_file data error:",SQLCA.sqlerrd[2]," ",lr_gax.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gax_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gax_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gba_file資料"
   LET li_count = 0
   DECLARE gba_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gba_file
            WHERE gba01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gba_file')
   FOREACH gba_o_curs INTO lr_gba.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gba_file patchtemp FOREACH 資料時產生錯誤，gba資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gba_file VALUES(lr_gba.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gba_file SET gba_file.* = lr_gba.*
          WHERE gba01 = lr_gba.gba01 AND gba02 = lr_gba.gba02
            AND gba03 = lr_gba.gba03 AND gba04 = lr_gba.gba04
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gba_file data error:",SQLCA.sqlerrd[2]," ",lr_gba.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gba_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gba_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gbb_file資料"
   LET li_count = 0
   DECLARE gbb_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gbb_file
             WHERE gbb01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gbb_file')
                OR gbb01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gba_file')             
   FOREACH gbb_o_curs INTO lr_gbb.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gbb_file patchtemp FOREACH 資料時產生錯誤，gbb資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gbb_file VALUES(lr_gbb.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gbb_file SET gbb_file.* = lr_gbb.*
          WHERE gbb01 = lr_gbb.gbb01 AND gbb02 = lr_gbb.gbb02
            AND gbb03 = lr_gbb.gbb03 AND gbb04 = lr_gbb.gbb04
            AND gbb05 = lr_gbb.gbb05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gbb_file data error:",SQLCA.sqlerrd[2]," ",lr_gbb.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gbb_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gbb_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gbf_file資料"
   LET li_count = 0
   DECLARE gbf_o_curs CURSOR FOR
           SELECT * FROM patchtemp.gbf_file
             WHERE gbf01 IN(SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='gbf_file')   
   FOREACH gbf_o_curs INTO lr_gbf.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gbf_file patchtemp FOREACH 資料時產生錯誤，gbf資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gbf_file VALUES(lr_gbf.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gbf_file SET gbf_file.* = lr_gbf.*
          WHERE gbf01 = lr_gbf.gbf01 AND gbf02 = lr_gbf.gbf02
            AND gbf03 = lr_gbf.gbf03 AND gbf04 = lr_gbf.gbf04
            AND gbf06 = lr_gbf.gbf06
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gbf_file data error:",SQLCA.sqlerrd[2]," ",lr_gbf.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gbf_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gbf_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zad_file資料"
   LET li_count = 0
   DECLARE zad_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zad_file
            WHERE zad01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='zaa_file')
   FOREACH zad_o_curs INTO lr_zad.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zad_file patchtemp FOREACH 資料時產生錯誤，zad資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zad_file VALUES(lr_zad.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zad_file SET zad01 = lr_zad.zad01,zad02 = lr_zad.zad02,
                                zad03 = lr_zad.zad03,zad04 = lr_zad.zad04,
                                zad05 = lr_zad.zad05,zad06 = lr_zad.zad06,
                                zad07 = lr_zad.zad07,zad08 = lr_zad.zad08,
                                zad09 = lr_zad.zad09,zad10 = lr_zad.zad10,
                                zad11 = lr_zad.zad11
          WHERE zad01 = lr_zad.zad01 AND zad02 = lr_zad.zad02
            AND zad03 = lr_zad.zad03 AND zad04 = lr_zad.zad04
            AND zad05 = lr_zad.zad05 AND zad06 = lr_zad.zad06
            AND zad07 = lr_zad.zad07 AND zad08 = lr_zad.zad08
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zad_file data error:",SQLCA.sqlerrd[2]," ",lr_zad.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zad_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zad_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zae_file資料"
   LET li_count = 0
   DECLARE zae_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zae_file
   #         WHERE zae01 IN(SELECT tbkey01 FROM patchtemp.psl_file
   #                         WHERE tbname='zae_file')  
   FOREACH zae_o_curs INTO lr_zae.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zae_file patchtemp FOREACH 資料時產生錯誤，zae資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zae_file VALUES(lr_zae.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zae_file SET zae01 = lr_zae.zae01,zae02 = lr_zae.zae02,
                                zae03 = lr_zae.zae03,zae04 = lr_zae.zae04,
                                zae05 = lr_zae.zae05,zae06 = lr_zae.zae06,
                                zae07 = lr_zae.zae07,zae08 = lr_zae.zae08,
                                zae09 = lr_zae.zae09,zae10 = lr_zae.zae10
          WHERE zae01 = lr_zae.zae01 AND zae04 = lr_zae.zae04
            AND zae05 = lr_zae.zae05 AND zae08 = lr_zae.zae08
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zae_file data error:",SQLCA.sqlerrd[2]," ",lr_zae.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zae_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zae_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041  

   DISPLAY "開始更新wca_file資料"
   LET li_count = 0
   DECLARE wca_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wca_file
            WHERE wca01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wca_file')   
   FOREACH wca_o_curs INTO lr_wca.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wca_file patchtemp FOREACH 資料時產生錯誤，wca資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wca_file VALUES(lr_wca.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wca_file SET wca01 = lr_wca.wca01,wca02 = lr_wca.wca02,
                                wca03 = lr_wca.wca03,wca04 = lr_wca.wca04,
                                wca05 = lr_wca.wca05,wcaacti = lr_wca.wcaacti,
                                wcauser = lr_wca.wcauser,wcagrup = lr_wca.wcagrup,
                                wcamodu = lr_wca.wcamodu,wcadate = lr_wca.wcadate
          WHERE wca01 = lr_wca.wca01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wca_file data error:",SQLCA.sqlerrd[2]," ",lr_wca.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wca_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wca_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wcb_file資料"
   LET li_count = 0
   DECLARE wcb_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wcb_file
             WHERE wcb01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='wcb_file')
                OR wcb01 IN (SELECT tbkey01 FROM patchtemp.psl_file  #No.FUN-8C0067
                              WHERE tbname='wca_file')     #No.FUN-8C0067
   FOREACH wcb_o_curs INTO lr_wcb.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wcb_file patchtemp FOREACH 資料時產生錯誤，wcb資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wcb_file VALUES(lr_wcb.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wcb_file SET wcb01 = lr_wcb.wcb01,wcb02 = lr_wcb.wcb02,
                                wcb03 = lr_wcb.wcb03,wcb04 = lr_wcb.wcb04,
                                wcb05 = lr_wcb.wcb05,wcb06 = lr_wcb.wcb06,
                                wcb07 = lr_wcb.wcb07,wcb08 = lr_wcb.wcb08,
                                wcb09 = lr_wcb.wcb09,wcb10 = lr_wcb.wcb10,
                                wcb11 = lr_wcb.wcb11,wcb12 = lr_wcb.wcb12,
                                wcb13 = lr_wcb.wcb13,wcb14 = lr_wcb.wcb14
          WHERE wcb01 = lr_wcb.wcb01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wcb_file data error:",SQLCA.sqlerrd[2]," ",lr_wcb.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wcb_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wcb_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wcc_file資料"
   LET li_count = 0
   DECLARE wcc_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wcc_file
             WHERE wcc01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='wcc_file')
                OR wcc01 IN (SELECT tbkey01 FROM patchtemp.psl_file  #No.FUN-8C0067
                              WHERE tbname='wca_file')     #No.FUN-8C0067
   FOREACH wcc_o_curs INTO lr_wcc.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wcc_file patchtemp FOREACH 資料時產生錯誤，wcc資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wcc_file VALUES(lr_wcc.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wcc_file SET wcc01 = lr_wcc.wcc01,wcc02 = lr_wcc.wcc02,
                                wcc03 = lr_wcc.wcc03,wcc04 = lr_wcc.wcc04,
                                wcc05 = lr_wcc.wcc05,wcc06 = lr_wcc.wcc06,
                                wcc07 = lr_wcc.wcc07
          WHERE wcc01 = lr_wcc.wcc01 AND wcc02 = lr_wcc.wcc02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wcc_file data error:",SQLCA.sqlerrd[2]," ",lr_wcc.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wcc_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wcc_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wcd_file資料"
   LET li_count = 0
   DECLARE wcd_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wcd_file
             WHERE wcd01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                              WHERE tbname='wcd_file')
   FOREACH wcd_o_curs INTO lr_wcd.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wcd_file patchtemp FOREACH 資料時產生錯誤，wcd資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wcd_file VALUES(lr_wcd.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wcd_file SET wcd01 = lr_wcd.wcd01,wcd02 = lr_wcd.wcd02,
                                wcd03 = lr_wcd.wcd03,wcd04 = lr_wcd.wcd04,
                                wcd05 = lr_wcd.wcd05,wcd06 = lr_wcd.wcd06,
                                wcd07 = lr_wcd.wcd07
          WHERE wcd01 = lr_wcd.wcd01 AND wcd02 = lr_wcd.wcd02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wcd_file data error:",SQLCA.sqlerrd[2]," ",lr_wcd.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wcd_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wcd_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zaw_file資料"
   LET li_count = 0
   DECLARE zaw_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zaw_file
            WHERE zaw01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='zaw_file')   
   FOREACH zaw_o_curs INTO lr_zaw.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zaw_file patchtemp FOREACH 資料時產生錯誤，zaw資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF
   
      INSERT INTO ds.zaw_file VALUES(lr_zaw.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zaw_file SET zaw01 = lr_zaw.zaw01,zaw02 = lr_zaw.zaw02,
                                zaw03 = lr_zaw.zaw03,zaw04 = lr_zaw.zaw04,
                                zaw05 = lr_zaw.zaw05,zaw06 = lr_zaw.zaw06,
                                zaw07 = lr_zaw.zaw07,zaw08 = lr_zaw.zaw08,
                                zaw09 = lr_zaw.zaw09,zaw10 = lr_zaw.zaw10,
                                zaw11 = lr_zaw.zaw11,zaw12 = lr_zaw.zaw12,
                                zaw14 = lr_zaw.zaw14,zaw15 = lr_zaw.zaw15,  #TQC-920102 add
                                zaw16 = lr_zaw.zaw16,zaw17 = lr_zaw.zaw17,  #TQC-920102 add
                                zaw18 = lr_zaw.zaw18,                       #TQC-920102 add
                                zawdate = lr_zaw.zawdate,
                                zawgrup = lr_zaw.zawgrup,
                                zawmodu = lr_zaw.zawmodu,
                                zawuser = lr_zaw.zawuser
          WHERE zaw01 = lr_zaw.zaw01 AND zaw02 = lr_zaw.zaw02
            AND zaw03 = lr_zaw.zaw03 AND zaw04 = lr_zaw.zaw04
            AND zaw05 = lr_zaw.zaw05 AND zaw06 = lr_zaw.zaw06
            AND zaw07 = lr_zaw.zaw07 AND zaw10 = lr_zaw.zaw10  #TQC-920102 add zaw10
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zaw_file data error:",SQLCA.sqlerrd[2]," ",lr_zaw.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zaw_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zaw_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041   

   DISPLAY "開始更新zav_file資料"
   LET li_count = 0
   DECLARE zav_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zav_file
            WHERE zav01 = '2' AND zav02 IN (SELECT tbkey01 FROM patchtemp.psl_file
                                            WHERE tbname = 'zai_file')
   FOREACH zav_o_curs INTO lr_zav.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zav_file patchtemp FOREACH 資料時產生錯誤，zav資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zav_file VALUES(lr_zav.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zav_file SET zav01 = lr_zav.zav01,zav02 = lr_zav.zav02,
                                zav03 = lr_zav.zav03,zav04 = lr_zav.zav04,
                                zav05 = lr_zav.zav05,zav06 = lr_zav.zav06,
                                zav07 = lr_zav.zav07,zav08 = lr_zav.zav08,
                                zav09 = lr_zav.zav09,zav10 = lr_zav.zav10,
                                zav11 = lr_zav.zav11,zav12 = lr_zav.zav12,
                                zav13 = lr_zav.zav13,zav14 = lr_zav.zav14,
                                zav15 = lr_zav.zav15,zav16 = lr_zav.zav16,
                                zav17 = lr_zav.zav17,zav18 = lr_zav.zav18,
                                zav19 = lr_zav.zav19,zav20 = lr_zav.zav20,
                                zav21 = lr_zav.zav21,zav22 = lr_zav.zav22,
                                zav23 = lr_zav.zav23,zav24 = lr_zav.zav24
          WHERE zav01 = lr_zav.zav01 AND zav02 = lr_zav.zav02
            AND zav03 = lr_zav.zav03 AND zav04 = lr_zav.zav04
            AND zav05 = lr_zav.zav05 AND zav24 = lr_zav.zav24
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zav_file data error:",SQLCA.sqlerrd[2]," ",lr_zav.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zav_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zav_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   
   DISPLAY "開始更新zai_file資料"
   LET li_count = 0
   DECLARE zai_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zai_file
            WHERE zai01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file') 
   FOREACH zai_o_curs INTO lr_zai.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zai_file patchtemp FOREACH 資料時產生錯誤，zai資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zai_file VALUES(lr_zai.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zai_file SET zai01 = lr_zai.zai01,zai02 = lr_zai.zai02,
                                zai03 = lr_zai.zai03,zai04 = lr_zai.zai04,
                                zai05 = lr_zai.zai05,zaiuser = lr_zai.zaiuser,
                                zaigrup = lr_zai.zaigrup,zaimodu = lr_zai.zaimodu,
                                zaidate = lr_zai.zaidate,zai06 = lr_zai.zai06
                                
          WHERE zai01 = lr_zai.zai01 AND zai05 = lr_zai.zai05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zai_file data error:",SQLCA.sqlerrd[2]," ",lr_zai.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zai_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zai_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zaj_file資料"
   LET li_count = 0
   DECLARE zaj_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zaj_file
            WHERE zaj01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zaj_o_curs INTO lr_zaj.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zaj_file patchtemp FOREACH 資料時產生錯誤，zaj資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zaj_file VALUES(lr_zaj.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zaj_file SET zaj01 = lr_zaj.zaj01,zaj02 = lr_zaj.zaj02,
                                zaj03 = lr_zaj.zaj03,zaj04 = lr_zaj.zaj04,
                                zaj05 = lr_zaj.zaj05,zaj06 = lr_zaj.zaj06,
                                zaj07 = lr_zaj.zaj07
          WHERE zaj01 = lr_zaj.zaj01 AND zaj02 = lr_zaj.zaj02 AND zaj07 = lr_zaj.zaj07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zaj_file data error:",SQLCA.sqlerrd[2]," ",lr_zaj.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zaj_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zaj_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zak_file資料"
   LET li_count = 0
   DECLARE zak_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zak_file
            WHERE zak01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zak_o_curs INTO lr_zak.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zak_file patchtemp FOREACH 資料時產生錯誤，zak資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zak_file VALUES(lr_zak.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zak_file SET zak01 = lr_zak.zak01,zak02 = lr_zak.zak02,
                                zak03 = lr_zak.zak03,zak04 = lr_zak.zak04,
                                zak05 = lr_zak.zak05,zak06 = lr_zak.zak06,
                                zak07 = lr_zak.zak07,zak08 = lr_zak.zak08
          WHERE zak01 = lr_zak.zak01 AND zak07 = lr_zak.zak07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zak_file data error:",SQLCA.sqlerrd[2]," ",lr_zak.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zak_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zak_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zal_file資料"
   LET li_count = 0
   DECLARE zal_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zal_file
            WHERE zal01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zal_o_curs INTO lr_zal.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zal_file patchtemp FOREACH 資料時產生錯誤，zal資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zal_file VALUES(lr_zal.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zal_file SET zal01 = lr_zal.zal01,zal02 = lr_zal.zal02,
                                zal03 = lr_zal.zal03,zal04 = lr_zal.zal04,
                                zal05 = lr_zal.zal05,zal06 = lr_zal.zal06,
                                zal07 = lr_zal.zal07,zal08 = lr_zal.zal08
          WHERE zal01 = lr_zal.zal01 AND zal02 = lr_zal.zal02
            AND zal03 = lr_zal.zal03 AND zal07 = lr_zal.zal07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zal_file data error:",SQLCA.sqlerrd[2]," ",lr_zal.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zal_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zal_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zam_file資料"
   LET li_count = 0
   DECLARE zam_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zam_file
            WHERE zam01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zam_o_curs INTO lr_zam.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zam_file patchtemp FOREACH 資料時產生錯誤，zam資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zam_file VALUES(lr_zam.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zam_file SET zam01 = lr_zam.zam01,zam02 = lr_zam.zam02,
                                zam03 = lr_zam.zam03,zam04 = lr_zam.zam04,
                                zam05 = lr_zam.zam05,zam06 = lr_zam.zam06,
                                zam07 = lr_zam.zam07,zam08 = lr_zam.zam08,
                                zam09 = lr_zam.zam09
          WHERE zam01 = lr_zam.zam01 AND zam02 = lr_zam.zam02 AND zam09=lr_zam.zam09
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zam_file data error:",SQLCA.sqlerrd[2]," ",lr_zam.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zam_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zam_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zan_file資料"
   LET li_count = 0
   DECLARE zan_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zan_file
            WHERE zan01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zan_o_curs INTO lr_zan.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zan_file patchtemp FOREACH 資料時產生錯誤，zan資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zan_file VALUES(lr_zan.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zan_file SET zan01 = lr_zan.zan01,zan02 = lr_zan.zan02,
                                zan03 = lr_zan.zan03,zan04 = lr_zan.zan04,
                                zan05 = lr_zan.zan05,zan06 = lr_zan.zan06,
                                zan07 = lr_zan.zan07,zan08 = lr_zan.zan08
          WHERE zan01 = lr_zan.zan01 AND zan02 = lr_zan.zan02 AND zan08 = lr_zan.zan08
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zan_file data error:",SQLCA.sqlerrd[2]," ",lr_zan.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zan_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zan_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zao_file資料"
   LET li_count = 0
   DECLARE zao_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zao_file
            WHERE zao01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zao_o_curs INTO lr_zao.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zao_file patchtemp FOREACH 資料時產生錯誤，zao資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zao_file VALUES(lr_zao.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zao_file SET zao01 = lr_zao.zao01,zao02 = lr_zao.zao02,
                                zao03 = lr_zao.zao03,zao04 = lr_zao.zao04,
                                zao05 = lr_zao.zao05
          WHERE zao01 = lr_zao.zao01 AND zao02 = lr_zao.zao02
            AND zao03 = lr_zao.zao03 AND zao05 = lr_zao.zao05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zao_file data error:",SQLCA.sqlerrd[2]," ",lr_zao.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zao_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zao_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zap_file資料"
   LET li_count = 0
   DECLARE zap_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zap_file
            WHERE zap01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zap_o_curs INTO lr_zap.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zap_file patchtemp FOREACH 資料時產生錯誤，zap資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zap_file VALUES(lr_zap.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zap_file SET zap01 = lr_zap.zap01,zap02 = lr_zap.zap02,
                                zap03 = lr_zap.zap03,zap04 = lr_zap.zap04,
                                zap05 = lr_zap.zap05,zap06 = lr_zap.zap06,
                                zap07 = lr_zap.zap07
          WHERE zap01 = lr_zap.zap01 AND zap07 = lr_zap.zap07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zap_file data error:",SQLCA.sqlerrd[2]," ",lr_zap.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zap_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zap_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zaq_file資料"
   LET li_count = 0
   DECLARE zaq_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zaq_file
            WHERE zaq01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zaq_o_curs INTO lr_zaq.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zaq_file patchtemp FOREACH 資料時產生錯誤，zaq資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zaq_file VALUES(lr_zaq.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zaq_file SET zaq01 = lr_zaq.zaq01,zaq02 = lr_zaq.zaq02,
                                zaq03 = lr_zaq.zaq03,zaq04 = lr_zaq.zaq04,
                                zaq05 = lr_zaq.zaq05
          WHERE zaq01 = lr_zaq.zaq01 AND zaq02 = lr_zaq.zaq02 AND zaq05 = lr_zaq.zaq05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zaq_file data error:",SQLCA.sqlerrd[2]," ",lr_zaq.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zaq_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zaq_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zar_file資料"
   LET li_count = 0
   DECLARE zar_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zar_file
            WHERE zar01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zar_o_curs INTO lr_zar.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zar_file patchtemp FOREACH 資料時產生錯誤，zar資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zar_file VALUES(lr_zar.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zar_file SET zar01 = lr_zar.zar01,zar02 = lr_zar.zar02,
                                zar03 = lr_zar.zar03,zar04 = lr_zar.zar04,
                                zar05 = lr_zar.zar05
          WHERE zar01 = lr_zar.zar01 AND zar02 = lr_zar.zar02
            AND zar03 = lr_zar.zar03 AND zar05 = lr_zar.zar05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zar_file data error:",SQLCA.sqlerrd[2]," ",lr_zar.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zar_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zar_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zas_file資料"
   LET li_count = 0
   DECLARE zas_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zas_file
            WHERE zas01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zas_o_curs INTO lr_zas.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zas_file patchtemp FOREACH 資料時產生錯誤，zas資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zas_file VALUES(lr_zas.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zas_file SET zas01 = lr_zas.zas01,zas02 = lr_zas.zas02,
                                zas03 = lr_zas.zas03,zas04 = lr_zas.zas04,
                                zas05 = lr_zas.zas05,zas06 = lr_zas.zas06,
                                zas07 = lr_zas.zas07,zas08 = lr_zas.zas08,
                                zas09 = lr_zas.zas09,zas10 = lr_zas.zas10,
                                zas11 = lr_zas.zas11
          WHERE zas01 = lr_zas.zas01 AND zas02 = lr_zas.zas02 AND zas11 = lr_zas.zas11
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zas_file data error:",SQLCA.sqlerrd[2]," ",lr_zas.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zas_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zas_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zat_file資料"
   LET li_count = 0
   DECLARE zat_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zat_file
            WHERE zat01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zat_o_curs INTO lr_zat.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zat_file patchtemp FOREACH 資料時產生錯誤，zat資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zat_file VALUES(lr_zat.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zat_file SET zat01 = lr_zat.zat01,zat02 = lr_zat.zat02,
                                zat03 = lr_zat.zat03,zat04 = lr_zat.zat04,
                                zat05 = lr_zat.zat05,zat06 = lr_zat.zat06,
                                zat07 = lr_zat.zat07,zat08 = lr_zat.zat08,
                                zat09 = lr_zat.zat09,zat10 = lr_zat.zat10,
                                zat11 = lr_zat.zat11
          WHERE zat01 = lr_zat.zat01 AND zat02 = lr_zat.zat02
            AND zat10 = lr_zat.zat10
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zat_file data error:",SQLCA.sqlerrd[2]," ",lr_zat.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zat_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zat_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新zau_file資料"
   LET li_count = 0
   DECLARE zau_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zau_file
            WHERE zau01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zau_o_curs INTO lr_zau.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zau_file patchtemp FOREACH 資料時產生錯誤，zau資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zau_file VALUES(lr_zau.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zau_file SET zau01 = lr_zau.zau01,zau02 = lr_zau.zau02,
                                zau03 = lr_zau.zau03,zau04 = lr_zau.zau04
          WHERE zau01 = lr_zau.zau01 AND zau04 = lr_zau.zau04
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zau_file data error:",SQLCA.sqlerrd[2]," ",lr_zau.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zau_file 更新完畢，共更新 ",li_count,"筆資料"                                 
   LET l_str = "zau_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   
   DISPLAY "開始更新zay_file資料"
   LET li_count = 0
   DECLARE zay_o_curs CURSOR FOR
           SELECT * FROM patchtemp.zay_file
            WHERE zay01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'zai_file')
   FOREACH zay_o_curs INTO lr_zay.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zay_file patchtemp FOREACH 資料時產生錯誤，zay資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zay_file VALUES(lr_zay.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zay_file SET zay01 = lr_zay.zay01,zay02 = lr_zay.zay02,
                                zay03 = lr_zay.zay03,zay04 = lr_zay.zay04,
                                zay05 = lr_zay.zay05,zay06 = lr_zay.zay06,
                                zay07 = lr_zay.zay07
          WHERE zay01 = lr_zay.zay01 AND zay02 = lr_zay.zay02
            AND zay03 = lr_zay.zay03 AND zay05 = lr_zay.zay05                
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload zay_file data error:",SQLCA.sqlerrd[2]," ",lr_zay.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zay_file 更新完畢，共更新 ",li_count,"筆資料"                                 
   LET l_str = "zay_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsm_file資料"
   LET li_count = 0
   DECLARE wsm_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsm_file
            WHERE wsm01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'wsm_file')
                             
   FOREACH wsm_o_curs INTO lr_wsm.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsm_file patchtemp FOREACH 資料時產生錯誤，wsm資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsm_file VALUES(lr_wsm.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsm_file SET wsm01 = lr_wsm.wsm01,wsm02 = lr_wsm.wsm02,
                                wsmacti = lr_wsm.wsmacti, wsmdate = lr_wsm.wsmdate,
                                wsmgrup = lr_wsm.wsmgrup, wsmmodu = lr_wsm.wsmmodu,
                                wsmuser = lr_wsm.wsmuser
          WHERE wsm01 = lr_wsm.wsm01 AND wsm02 = lr_wsm.wsm02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsm_file data error:",SQLCA.sqlerrd[2]," ",lr_wsm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsm_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsm_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsn_file資料"
   LET li_count = 0
   DECLARE wsn_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsn_file
            WHERE wsn01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'wsm_file') 
   FOREACH wsn_o_curs INTO lr_wsn.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsn_file patchtemp FOREACH 資料時產生錯誤，wsn資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsn_file VALUES(lr_wsn.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsn_file SET wsn01 = lr_wsn.wsn01,wsn02 = lr_wsn.wsn02,
                                wsn03 = lr_wsn.wsn03,wsn04 = lr_wsn.wsn04
          WHERE wsn01 = lr_wsn.wsn01 AND wsn02 = lr_wsn.wsn02 AND wsn03 = lr_wsn.wsn03
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsn_file data error:",SQLCA.sqlerrd[2]," ",lr_wsn.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsn_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsn_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wso_file資料"
   LET li_count = 0
   DECLARE wso_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wso_file
            WHERE wso01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'wsm_file')
   FOREACH wso_o_curs INTO lr_wso.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wso_file patchtemp FOREACH 資料時產生錯誤，wso資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wso_file VALUES(lr_wso.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wso_file SET wso01 = lr_wso.wso01,wso02 = lr_wso.wso02,
                                wso03 = lr_wso.wso03,wso04 = lr_wso.wso04,
                                wso05 = lr_wso.wso05
          WHERE wso01 = lr_wso.wso01 AND wso02 = lr_wso.wso02 AND wso03 = lr_wso.wso03 AND wso04 = lr_wso.wso04
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wso_file data error:",SQLCA.sqlerrd[2]," ",lr_wso.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wso_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wso_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsp_file資料"
   LET li_count = 0
   DECLARE wsp_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsp_file
            WHERE wsp01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname = 'wsm_file')
   FOREACH wsp_o_curs INTO lr_wsp.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsp_file patchtemp FOREACH 資料時產生錯誤，wsp資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsp_file VALUES(lr_wsp.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsp_file SET wsp01 = lr_wsp.wsp01,wsp02 = lr_wsp.wsp02,
                                wsp03 = lr_wsp.wsp03,wsp04 = lr_wsp.wsp04,
                                wsp05 = lr_wsp.wsp05
          WHERE wsp01 = lr_wsp.wsp01 AND wsp02 = lr_wsp.wsp02 AND wsp03 = lr_wsp.wsp03 AND wsp04 = lr_wsp.wsp04
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsp_file data error:",SQLCA.sqlerrd[2]," ",lr_wsp.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsp_file 更新完畢，共更新 ",li_count,"筆資料"      
   LET l_str = "wsp_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   #FUN-8A0115 --add- start--  加入TABLE
   #加入wsr_file 
   DISPLAY "開始更新wsr_file資料"
   LET li_count = 0
   DECLARE wsr_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsr_file
                   WHERE wsr01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                                   WHERE tbname = 'wsm_file')     # 由wsm_file  對照?! R 選項
   FOREACH wsr_o_curs INTO lr_wsr.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsr_file patchtemp FOREACH 資料時產生錯誤，wsr資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsr_file VALUES(lr_wsr.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsr_file SET wsr01 = lr_wsr.wsr01,wsr02 = lr_wsr.wsr02,
                                wsr03 = lr_wsr.wsr03,wsr04 = lr_wsr.wsr04,
                                wsracti = lr_wsr.wsracti, wsrdate = lr_wsr.wsrdate,
                                wsrgrup = lr_wsr.wsrgrup, wsrmodu = lr_wsr.wsrmodu,
                                wsruser = lr_wsr.wsruser
          WHERE wsr01 = lr_wsr.wsr01 AND wsr02 = lr_wsr.wsr02 
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsr_file data error:",SQLCA.sqlerrd[2]," ",lr_wsr.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsr_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsr_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   #加入wss_file
   DISPLAY "開始更新wss_file資料"
   LET li_count = 0
   DECLARE wss_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wss_file
                    WHERE wss01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                                    WHERE tbname = 'wsm_file')
   FOREACH wss_o_curs INTO lr_wss.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wss_file patchtemp FOREACH 資料時產生錯誤，wss資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wss_file VALUES(lr_wss.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wss_file SET wss01 = lr_wss.wss01,wss02 = lr_wss.wss02,
                                wss03 = lr_wss.wss03,wss04 = lr_wss.wss04,
                                wss05 = lr_wss.wss05,wss06 = lr_wss.wss06
          WHERE wss01 = lr_wss.wss01 AND wss02 = lr_wss.wss02 AND wss03 = lr_wss.wss03 AND wss04 = lr_wss.wss04
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wss_file data error:",SQLCA.sqlerrd[2]," ",lr_wss.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wss_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wss_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   #加入wst_file
   DISPLAY "開始更新wst_file資料"
   LET li_count = 0
   DECLARE wst_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wst_file
                   WHERE wst01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                                   WHERE tbname = 'wsm_file')
   FOREACH wst_o_curs INTO lr_wst.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wst_file patchtemp FOREACH 資料時產生錯誤，wst資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wst_file VALUES(lr_wst.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wst_file SET wst01 = lr_wst.wst01,wst02 = lr_wst.wst02,
                                wst03 = lr_wst.wst03,wst04 = lr_wst.wst04,
                                wst05 = lr_wst.wst05,wst06 = lr_wst.wst06
          WHERE wst01 = lr_wst.wst01 AND wst02 = lr_wst.wst02 AND wst03 = lr_wst.wst03 AND wst04 = lr_wst.wst04 
                AND wst05 = lr_wst.wst05        
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wst_file data error:",SQLCA.sqlerrd[2]," ",lr_wst.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wst_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wst_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041   

   #加入wgf_file
   DISPLAY "開始更新wgf_file資料"
   LET li_count = 0
   DECLARE wgf_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wgf_file
                   WHERE wgf01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                                   WHERE tbname = 'wgf_file')    # wgf_file 
   FOREACH wgf_o_curs INTO lr_wgf.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wgf_file patchtemp FOREACH 資料時產生錯誤，wgf資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wgf_file VALUES(lr_wgf.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wgf_file SET wgf01 = lr_wgf.wgf01,wgf02 = lr_wgf.wgf02,
                                wgf03 = lr_wgf.wgf03
          WHERE wgf01 = lr_wgf.wgf01 
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wgf_file data error:",SQLCA.sqlerrd[2]," ",lr_wgf.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wgf_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wgf_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   #FUN-8A0115 --add - end -

   #No.FUN-8C0005 --start--
   DISPLAY "開始更新wsd_file資料"
   LET li_count = 0
   DECLARE wsd_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsd_file
            WHERE wsd01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wsd_o_curs INTO lr_wsd.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsd_file patchtemp FOREACH 資料時產生錯誤，wsd資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsd_file VALUES(lr_wsd.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsd_file SET wsd_file.* = lr_wsd.*
          WHERE wsd01 = lr_wsd.wsd01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsd_file data error:",SQLCA.sqlerrd[2]," ",lr_wsd.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsd_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsd_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wse_file資料"
   LET li_count = 0
   DECLARE wse_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wse_file
            WHERE wse01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wse_o_curs INTO lr_wse.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wse_file patchtemp FOREACH 資料時產生錯誤，wse資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wse_file VALUES(lr_wse.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wse_file SET wse_file.* = lr_wse.*
          WHERE wse01 = lr_wse.wse01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wse_file data error:",SQLCA.sqlerrd[2]," ",lr_wse.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wse_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wse_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsf_file資料"
   LET li_count = 0
   DECLARE wsf_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsf_file
            WHERE wsf01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wsf_o_curs INTO lr_wsf.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsf_file patchtemp FOREACH 資料時產生錯誤，wsf資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsf_file VALUES(lr_wsf.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsf_file SET wsf_file.* = lr_wsf.*
          WHERE wsf01 = lr_wsf.wsf01 AND wsf02 = lr_wsf.wsf02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsf_file data error:",SQLCA.sqlerrd[2]," ",lr_wsf.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsf_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsf_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsg_file資料"
   LET li_count = 0
   DECLARE wsg_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsg_file
            WHERE wsg01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wsg_o_curs INTO lr_wsg.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsg_file patchtemp FOREACH 資料時產生錯誤，wsg資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsg_file VALUES(lr_wsg.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsg_file SET wsg_file.* = lr_wsg.*
          WHERE wsg01 = lr_wsg.wsg01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsg_file data error:",SQLCA.sqlerrd[2]," ",lr_wsg.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsg_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsg_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsh_file資料"
   LET li_count = 0
   DECLARE wsh_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsh_file
            WHERE wsh01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wsh_o_curs INTO lr_wsh.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsh_file patchtemp FOREACH 資料時產生錯誤，wsh資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsh_file VALUES(lr_wsh.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsh_file SET wsh_file.* = lr_wsh.*
          WHERE wsh01 = lr_wsh.wsh01 AND wsh02 = lr_wsh.wsh02
            AND wsh03 = lr_wsh.wsh03 AND wsh04 = lr_wsh.wsh04
            AND wsh05 = lr_wsh.wsh05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsh_file data error:",SQLCA.sqlerrd[2]," ",lr_wsh.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsh_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsh_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wsi_file資料"
   LET li_count = 0
   DECLARE wsi_o_curs CURSOR FOR
           SELECT * FROM patchtemp.wsi_file
            WHERE wsi01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='wsa_file')
   FOREACH wsi_o_curs INTO lr_wsi.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wsi_file patchtemp FOREACH 資料時產生錯誤，wsi資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wsi_file VALUES(lr_wsi.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wsi_file SET wsi_file.* = lr_wsi.*
          WHERE wsi01 = lr_wsi.wsi01 AND wsi02 = lr_wsi.wsi02
            AND wsi05 = lr_wsi.wsi05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wsi_file data error:",SQLCA.sqlerrd[2]," ",lr_wsi.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wsi_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wsi_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   #No.FUN-8C0005 ---end---

   #No.FUN-8C0067 --start--
   DISPLAY "開始更新wah_file資料"
   LET li_count = 0
   DECLARE wah_o_curs CURSOR FOR
           SELECT wah_file.* FROM patchtemp.wah_file,patchtemp.psl_file
            WHERE wah01 = tbkey01 AND wah02 = tbkey02 AND tbname = 'wah_file'
   FOREACH wah_o_curs INTO lr_wah.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wah_file patchtemp FOREACH 資料時產生錯誤，wah資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wah_file VALUES(lr_wah.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wah_file SET wah_file.* = lr_wah.*
          WHERE wah01 = lr_wah.wah01 AND wah02 = lr_wah.wah02
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wah_file data error:",SQLCA.sqlerrd[2]," ",lr_wah.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wah_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wah_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wai_file資料"
   LET li_count = 0
   DECLARE wai_o_curs CURSOR FOR
           SELECT wai_file.* FROM patchtemp.wai_file,patchtemp.psl_file
            WHERE wai01 = tbkey01 AND wai02 = tbkey02 AND tbname = 'wah_file'
   FOREACH wai_o_curs INTO lr_wai.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wai_file patchtemp FOREACH 資料時產生錯誤，wai資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wai_file VALUES(lr_wai.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wai_file SET wai_file.* = lr_wai.*
          WHERE wai01 = lr_wai.wai01 AND wai03 = lr_wai.wai03
            AND wai05 = lr_wai.wai05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wai_file data error:",SQLCA.sqlerrd[2]," ",lr_wai.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wai_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wai_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新waj_file資料"
   LET li_count = 0
   DECLARE waj_o_curs CURSOR FOR
           SELECT waj_file.* FROM patchtemp.waj_file,patchtemp.psl_file
            WHERE waj01 = tbkey01 AND waj02 = tbkey02 AND tbname = 'wah_file'
   FOREACH waj_o_curs INTO lr_waj.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "waj_file patchtemp FOREACH 資料時產生錯誤，waj資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.waj_file VALUES(lr_waj.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.waj_file SET waj_file.* = lr_waj.*
          WHERE waj01 = lr_waj.waj01 AND waj02 = lr_waj.waj02
            AND waj04 = lr_waj.waj04 AND waj05 = lr_waj.waj05
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload waj_file data error:",SQLCA.sqlerrd[2]," ",lr_waj.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "waj_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "waj_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新waa_file資料"
   LET li_count = 0
   DECLARE waa_o_curs CURSOR FOR
          #SELECT waa_file.* FROM patchtemp.waa_file,patchtemp.psl_file #CHI-920020 mark
           SELECT waa_file.* FROM patchtemp.waa_file                    #CHI-920020 mod
            WHERE waa01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='waa_file')
               OR waa01 IN (SELECT tbkey02 FROM patchtemp.psl_file
                             WHERE tbname='wah_file')
   FOREACH waa_o_curs INTO lr_waa.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "waa_file patchtemp FOREACH 資料時產生錯誤，waa資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.waa_file VALUES(lr_waa.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.waa_file SET waa_file.* = lr_waa.*
          WHERE waa01 = lr_waa.waa01
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload waa_file data error:",SQLCA.sqlerrd[2]," ",lr_waa.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "waa_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "waa_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wab_file資料"
   LET li_count = 0
   DECLARE wab_o_curs CURSOR FOR
          #SELECT wab_file.* FROM patchtemp.wab_file,patchtemp.psl_file #CHI-920020 mark
           SELECT wab_file.* FROM patchtemp.wab_file                    #CHI-920020 mod
            WHERE wab01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='waa_file')
               OR wab01 IN (SELECT tbkey02 FROM patchtemp.psl_file
                             WHERE tbname='wah_file')
   FOREACH wab_o_curs INTO lr_wab.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wab_file patchtemp FOREACH 資料時產生錯誤，wab資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wab_file VALUES(lr_wab.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wab_file SET wab_file.* = lr_wab.*
          WHERE wab01 = lr_wab.wab01 AND wab09 = lr_wab.wab09
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wab_file data error:",SQLCA.sqlerrd[2]," ",lr_wab.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wab_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wab_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wac_file資料"
   LET li_count = 0
   DECLARE wac_o_curs CURSOR FOR
          #SELECT wac_file.* FROM patchtemp.wac_file,patchtemp.psl_file  #CHI-920020 mark
           SELECT wac_file.* FROM patchtemp.wac_file                     #CHI-920020 mod
            WHERE wac01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                             WHERE tbname='waa_file')
               OR wac01 IN (SELECT tbkey02 FROM patchtemp.psl_file
                             WHERE tbname='wah_file')
   FOREACH wac_o_curs INTO lr_wac.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wac_file patchtemp FOREACH 資料時產生錯誤，wac資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wac_file VALUES(lr_wac.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wac_file SET wac_file.* = lr_wac.*
          WHERE wac01 = lr_wac.wac01 AND wac02 = lr_wac.wac02
            AND wac03 = lr_wac.wac03
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload wac_file data error:",SQLCA.sqlerrd[2]," ",lr_wac.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wac_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wac_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   #No.FUN-8C0067 ---end---

   # No.FUN-960050 ---start---
   DISPLAY "開始更新wad_file資料"
   LET li_count = 0
   DECLARE wad_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wad_file
     WHERE wad01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wad_file')
   FOREACH wad_o_curs INTO lr_wad.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wad_file patchtemp FOREACH 資料時產生錯誤，wad資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wad_file VALUES(lr_wad.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wad_file SET wad_file.* = lr_wad.*
          WHERE wad01 = lr_wad.wad01 AND wad04 = lr_wad.wad04
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wad_file data error:",SQLCA.sqlerrd[2]," ",lr_wad.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wad_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wad_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新wae_file資料"
   LET li_count = 0
   DECLARE wae_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wae_file
     WHERE wae01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wad_file')
   FOREACH wae_o_curs INTO lr_wae.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wae_file patchtemp FOREACH 資料時產生錯誤，wae資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wae_file VALUES(lr_wae.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wae_file SET wae_file.* = lr_wae.*
          WHERE wae01 = lr_wae.wae01 AND wae02 = lr_wae.wae02 AND wae13 = lr_wae.wae13
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wae_file data error:",SQLCA.sqlerrd[2]," ",lr_wae.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wae_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wae_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
 
   DISPLAY "開始更新wan_file資料"
   LET li_count = 0
   DECLARE wan_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wan_file
     WHERE wan03 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wad_file')
        # No:TQC-BB0079 ---start---
        OR wan03 IN (SELECT tbkey01 FROM patchtemp.psl_file
                      WHERE tbname='wao_file')
        # No:TQC-BB0079 --- end ---
   FOREACH wan_o_curs INTO lr_wan.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wan_file patchtemp FOREACH 資料時產生錯誤，wan資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wan_file VALUES(lr_wan.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wan_file SET wan_file.* = lr_wan.*
          WHERE wan01 = lr_wan.wan01 AND wan02 = lr_wan.wan02 AND wan03 = lr_wan.wan03
            AND wan04 = lr_wan.wan04 AND wan05 = lr_wan.wan05
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wan_file data error:",SQLCA.sqlerrd[2]," ",lr_wan.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wan_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wan_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No.FUN-960050 --- end ---

   # No:FUN-A30105 ---start---
   DISPLAY "開始更新gee_file資料"
   LET li_count = 0
   DECLARE gee_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gee_file
     WHERE gee01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gee_file')
   FOREACH gee_o_curs INTO lr_gee.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gee_file patchtemp FOREACH 資料時產生錯誤，gee資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gee_file VALUES(lr_gee.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gee_file SET gee_file.* = lr_gee.*
          WHERE gee01 = lr_gee.gee01 AND gee02 = lr_gee.gee02 AND gee03 = lr_gee.gee03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gee_file data error:",SQLCA.sqlerrd[2]," ",lr_gee.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gee_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gee_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No.FUN-960050 --- end ---

   # No:FUN-A60053 ---start---
   DISPLAY "開始更新zta_file資料"
   LET li_count = 0
   DECLARE zta_o_curs CURSOR FOR
    SELECT * FROM patchtemp.zta_file
     WHERE zta01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='zta_file')
   FOREACH zta_o_curs INTO lr_zta.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "zta_file patchtemp FOREACH 資料時產生錯誤，zta資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.zta_file VALUES(lr_zta.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.zta_file SET zta_file.* = lr_zta.*
          WHERE zta01 = lr_zta.zta01 AND zta02 = lr_zta.zta02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload zta_file data error:",SQLCA.sqlerrd[2]," ",lr_zta.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "zta_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "zta_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No:FUN-A60053 --- end ---

   # No:FUN-B60121 ---start---
   DISPLAY "開始更新wao_file資料"
   LET li_count = 0
   DECLARE wao_o_curs CURSOR FOR
    SELECT * FROM patchtemp.wao_file
     WHERE wao01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='wao_file')
   FOREACH wao_o_curs INTO lr_wao.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "wao_file patchtemp FOREACH 資料時產生錯誤，wao資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.wao_file VALUES(lr_wao.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.wao_file SET wao_file.* = lr_wao.*
          WHERE wao01 = lr_wao.wao01 AND wao02 = lr_wao.wao02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload wao_file data error:",SQLCA.sqlerrd[2]," ",lr_wao.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "wao_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "wao_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gdw_file資料"
   LET li_count = 0
   DECLARE gdw_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gdw_file
     WHERE gdw01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gdw_file')
   FOREACH gdw_o_curs INTO lr_gdw.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdw_file patchtemp FOREACH 資料時產生錯誤，gdw資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdw_file VALUES(lr_gdw.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdw_file SET gdw_file.* = lr_gdw.*
          WHERE gdw01 = lr_gdw.gdw01 AND gdw02 = lr_gdw.gdw02
            AND gdw03 = lr_gdw.gdw03 AND gdw04 = lr_gdw.gdw04
            AND gdw05 = lr_gdw.gdw05 AND gdw06 = lr_gdw.gdw06
            AND gdw07 = lr_gdw.gdw07
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdw_file data error:",SQLCA.sqlerrd[2]," ",lr_gdw.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdw_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdw_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gdm_file資料"
   LET li_count = 0
   # No:TQC-BB0079 ---modify start---
   DECLARE gdm_o_curs CURSOR FOR
#   SELECT * FROM patchtemp.gdm_file
#    WHERE gdm01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
#                     WHERE tbname='gdw_file')
    SELECT gdm_file.* FROM patchtemp.gdm_file,patchtemp.gdw_file   # No:TQC-BB0079
     WHERE gdw01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                      WHERE tbname='gdw_file')
       AND gdw08 = gdm01
   # No:TQC-BB0079 --- modify end ---

   FOREACH gdm_o_curs INTO lr_gdm.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdm_file patchtemp FOREACH 資料時產生錯誤，gdm資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdm_file VALUES(lr_gdm.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdm_file SET gdm_file.* = lr_gdm.*
          WHERE gdm01 = lr_gdm.gdm01 AND gdm02 = lr_gdm.gdm02
            AND gdm03 = lr_gdm.gdm03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdm_file data error:",SQLCA.sqlerrd[2]," ",lr_gdm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdm_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdm_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   # No:DEV-C40001 ---start---
   DISPLAY "開始更新gfs_file資料"
   LET li_count = 0
   DECLARE gfs_o_curs CURSOR FOR
    SELECT gfs_file.* FROM patchtemp.gfs_file,patchtemp.gdw_file
     WHERE gdw01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                      WHERE tbname='gdw_file')
       AND gdw08 = gfs01

   FOREACH gfs_o_curs INTO lr_gfs.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gfs_file patchtemp FOREACH 資料時產生錯誤，gfs資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gfs_file VALUES(lr_gfs.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gfs_file SET gfs_file.* = lr_gfs.*
          WHERE gfs01 = lr_gfs.gfs01 AND gfs02 = lr_gfs.gfs02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gfs_file data error:",SQLCA.sqlerrd[2]," ",lr_gfs.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gfs_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gfs_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No:DEV-C40001 --- end ---

   DISPLAY "開始更新gdo_file資料"
   LET li_count = 0
   DECLARE gdo_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gdo_file
     WHERE gdo01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gdo_file')
   FOREACH gdo_o_curs INTO lr_gdo.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdo_file patchtemp FOREACH 資料時產生錯誤，gdo資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdo_file VALUES(lr_gdo.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdo_file SET gdo_file.* = lr_gdo.*
          WHERE gdo01 = lr_gdo.gdo01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdo_file data error:",SQLCA.sqlerrd[2]," ",lr_gdo.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdo_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdo_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No:FUN-B60121 --- end ---

   # No:FUN-BB0011 ---start---
   DISPLAY "開始更新gfn_file資料"
   LET li_count = 0
   DECLARE gfn_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gfn_file
     WHERE gfn01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gfn_file')
   FOREACH gfn_o_curs INTO lr_gfn.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gfn_file patchtemp FOREACH 資料時產生錯誤，gfn資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gfn_file VALUES(lr_gfn.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gfn_file SET gfn_file.* = lr_gfn.*
          WHERE gfn01 = lr_gfn.gfn01 AND gfn02 = lr_gfn.gfn02
            AND gfn03 = lr_gfn.gfn03 AND gfn04 = lr_gfn.gfn04
            AND gfn05 = lr_gfn.gfn05 AND gfn06 = lr_gfn.gfn06
            AND gfn07 = lr_gfn.gfn07
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gfn_file data error:",SQLCA.sqlerrd[2]," ",lr_gfn.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gfn_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gfn_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gfm_file資料"
   LET li_count = 0
   DECLARE gfm_o_curs CURSOR FOR
    SELECT gfm_file.* FROM patchtemp.gfm_file,patchtemp.gfn_file
     WHERE gfn01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                      WHERE tbname='gfn_file')
       AND gfn02 = gfm01
   FOREACH gfm_o_curs INTO lr_gfm.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gfm_file patchtemp FOREACH 資料時產生錯誤，gfm資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gfm_file VALUES(lr_gfm.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gfm_file SET gfm_file.* = lr_gfm.*
          WHERE gfm01 = lr_gfm.gfm01 AND gfm02 = lr_gfm.gfm02
            AND gfm03 = lr_gfm.gfm03 AND gfm04 = lr_gfm.gfm04
            AND gfm05 = lr_gfm.gfm05 AND gfm06 = lr_gfm.gfm06
            AND gfm07 = lr_gfm.gfm07
         IF SQLCA.sqlcode THEN
            LET l_cmd = "upload gfm_file data error:",SQLCA.sqlerrd[2]," ",lr_gfm.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gfm_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gfm_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gfp_file資料"
   LET li_count = 0
   DECLARE gfp_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gfp_file
     WHERE gfp01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gfn_file')
   FOREACH gfp_o_curs INTO lr_gfp.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gfp_file patchtemp FOREACH 資料時產生錯誤，gfp資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gfp_file VALUES(lr_gfp.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gfp_file SET gfp_file.* = lr_gfp.*
          WHERE gfp01 = lr_gfp.gfp01 AND gfp02 = lr_gfp.gfp02
            AND gfp03 = lr_gfp.gfp03
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gfp_file data error:",SQLCA.sqlerrd[2]," ",lr_gfp.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gfp_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gfp_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gdk_file資料"
   LET li_count = 0
   DECLARE gdk_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gdk_file
     WHERE gdk01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gfn_file')
   FOREACH gdk_o_curs INTO lr_gdk.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdk_file patchtemp FOREACH 資料時產生錯誤，gdk資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdk_file VALUES(lr_gdk.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdk_file SET gdk_file.* = lr_gdk.*
          WHERE gdk01 = lr_gdk.gdk01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdk_file data error:",SQLCA.sqlerrd[2]," ",lr_gdk.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdk_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdk_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041

   DISPLAY "開始更新gdl_file資料"
   LET li_count = 0
   DECLARE gdl_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gdl_file
     WHERE gdl01 = 'default'
   FOREACH gdl_o_curs INTO lr_gdl.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdl_file patchtemp FOREACH 資料時產生錯誤，gdl資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdl_file VALUES(lr_gdl.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdl_file SET gdl_file.* = lr_gdl.*
          WHERE gdl01 = lr_gdl.gdl01 AND gdl02 = lr_gdl.gdl02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdl_file data error:",SQLCA.sqlerrd[2]," ",lr_gdl.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdl_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdl_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   #TQC-C70041
   # No:FUN-BB0011 --- end ---

   # No:FUN-CB0095 ---start---
   DISPLAY "開始更新gdr_file資料"
   LET li_count = 0
   DECLARE gdr_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gdr_file
     WHERE gdr01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gdr_file')
   FOREACH gdr_o_curs INTO lr_gdr.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gdr_file patchtemp FOREACH 資料時產生錯誤，gdr資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gdr_file VALUES(lr_gdr.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gdr_file SET gdr_file.* = lr_gdr.*
          WHERE gdr00 = lr_gdr.gdr00 AND gdr03 = lr_gdr.gdr03
            AND gdr06 = lr_gdr.gdr06 AND gdr07 = lr_gdr.gdr07
            AND gdr08 = lr_gdr.gdr08 AND gdr10 = lr_gdr.gdr10
            AND gdr11 = lr_gdr.gdr11 AND gdr12 = lr_gdr.gdr12 
            AND gdr13 = lr_gdr.gdr13 AND gdr19 = lr_gdr.gdr19 
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gdr_file data error:",SQLCA.sqlerrd[2]," ",lr_gdr.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gdr_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gdr_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   

   DISPLAY "開始更新gds_file資料"
   LET li_count = 0
   DECLARE gds_o_curs CURSOR FOR
    SELECT gds_file.* FROM patchtemp.gds_file,patchtemp.gdr_file   
     WHERE gdr01 IN (SELECT tbkey01 FROM patchtemp.psl_file
                      WHERE tbname='gdr_file')
       AND gds00 = gdr00

   FOREACH gds_o_curs INTO lr_gds.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gds_file patchtemp FOREACH 資料時產生錯誤，gds資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gds_file VALUES(lr_gds.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gds_file SET gds_file.* = lr_gds.*
          WHERE gds00 = lr_gds.gds00 AND gds01 = lr_gds.gds01
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gds_file data error:",SQLCA.sqlerrd[2]," ",lr_gds.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gds_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gds_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   
   # No:FUN-CB0095 ---end---

   # No:FUN-D10131 ---start---
   DISPLAY "開始更新gbl_file資料"
   LET li_count = 0
   DECLARE gbl_o_curs CURSOR FOR
    SELECT * FROM patchtemp.gbl_file
     WHERE gbl01 IN (SELECT tbkey01 FROM patchtemp.psl_file 
                      WHERE tbname='gbl_file')

   FOREACH gbl_o_curs INTO lr_gbl.*
      IF SQLCA.sqlcode THEN
         LET l_cmd = "gbl_file patchtemp FOREACH 資料時產生錯誤，gbl資料無更新"
         CALL gc_channel.write(l_cmd)
         EXIT FOREACH
      END IF

      INSERT INTO ds.gbl_file VALUES(lr_gbl.*)
      IF SQLCA.sqlcode THEN
         UPDATE ds.gbl_file SET gbl_file.* = lr_gbl.*
          WHERE gbl01 = lr_gbl.gbl01 AND gbl02 = lr_gbl.gbl02
         IF SQLCA.sqlcode THEN    
            LET l_cmd = "upload gbl_file data error:",SQLCA.sqlerrd[2]," ",lr_gbl.*
            CALL gc_channel.write(l_cmd)
            LET l_result = FALSE
         ELSE
            LET li_count = li_count + SQLCA.sqlerrd[3]
         END IF
      ELSE
         LET li_count = li_count + SQLCA.sqlerrd[3]
      END IF
   END FOREACH
   DISPLAY "gbl_file 更新完畢，共更新 ",li_count,"筆資料"
   LET l_str = "gbl_file 更新完畢，共更新 ",li_count,"筆資料"
   CALL gs_channel.write(l_str)   
   # No:FUN-D10131 --- end ---

   # No:FUN-C20069 ---start---
   # 因為web區的資料在做update時遭遇很多問題，
   # EX:變數定義、update段無法compile通過、INSERT失敗程式無法繼續往下執行.....
   # 與小鷰測試過很多方式，包含用sql語法去改寫、使用預定義變數的方式，
   # 但都會遇到一些問題，最後測試出用呼叫副程式的方式來進行，
   # 因此此後p_unpack2程式會多link p_unpack2_web_dataupdate.4gl，
   # 此程式主要用來處理wds資料庫的資料處理部分，包含INSERT及UPDATE段

   CALL p_unpack2_web_dataupdate(g_tarname) RETURNING l_result
   # No:FUN-C20069 --- end ---
 
   IF NOT l_result THEN
      LET l_cmd = ""
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "zz_file,zm_file,gak_file,gal_file上述幾個table若資料無法LOAD"
      CALL gc_channel.write(l_cmd)
      LET l_cmd = "可能客戶端已更改成客制資料, 請手動查看是否需更新"
      CALL gc_channel.write(l_cmd)
   END IF
   
   #TQC-C70041 -- add start --
   LET l_cmd = ""
   CALL gs_channel.write(l_cmd)
   LET l_cmd = "以上為解包過程LOAD成功的總筆數，請比對PATCH包中的TXT檔案筆數是否一致"
   CALL gs_channel.write(l_cmd)

   CALL gc_channel.close()
   CALL gs_channel.close()   #TQC-C70041 add
END FUNCTION
 
 
FUNCTION tar_source()
   DEFINE l_cmd        STRING
   DEFINE l_date       LIKE type_file.chr6
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ac         LIKE type_file.num5
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE l_cnt2       LIKE type_file.num5    #TQC-BB0113 add 
   DEFINE l_tempdir    STRING
   DEFINE l_topdir     STRING
   DEFINE l_str        STRING
   DEFINE ls_str       STRING
   DEFINE lc_channel   base.Channel
   DEFINE ld_channel   base.Channel
   DEFINE le_channel   base.Channel
   DEFINE l_row        LIKE type_file.num5
   DEFINE lc_str       DYNAMIC ARRAY OF STRING
   DEFINE ld_str       DYNAMIC ARRAY OF STRING
   DEFINE l_flow       DYNAMIC ARRAY OF STRING
   DEFINE la_str       DYNAMIC ARRAY OF STRING
   DEFINE lb_str       DYNAMIC ARRAY OF STRING
   DEFINE l_string     STRING
   DEFINE l_string1    STRING #FUN-860059 add
   DEFINE l_syc06      LIKE type_file.chr100    # No:FUN-C90054
   DEFINE l_rowcnt     LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5   
   DEFINE l_flag       LIKE type_file.num5 #TQC-840034
   DEFINE l_unpack_path     STRING              # No:FUN-A90064
   DEFINE l_tarname_path    STRING              # No:FUN-A90064
   DEFINE l_file            STRING              # No:FUN-A90064
   DEFINE l_back_file       STRING              # No:FUN-A90064
   DEFINE l_record_file     STRING              # No:FUN-A90064
   DEFINE l_record_file2    STRING              # No:FUN-A90064
   DEFINE l_source_file     STRING              # No:FUN-A90064
   DEFINE l_copied_file     STRING              # No:FUN-A90064
   DEFINE l_tarname_file    STRING              # No:FUN-A90064
   DEFINE l_h               LIKE type_file.num5 # No:FUN-A90064
   DEFINE l_idx             LIKE type_file.num5 # No:FUN-A90064
   DEFINE l_file1           STRING              # No:FUN-BA0022
   DEFINE l_err_xls         STRING              # No:TQC-BB0216
   DEFINE ls_cnt            LIKE type_file.chr1 # No:TQC-BB0216
 
   LET l_date = TODAY USING "yymmdd"
   LET l_topdir =FGL_GETENV('TOP')
   LET l_tempdir=FGL_GETENV('TEMPDIR')

   # No:FUN-A90064 ---start---
   LET l_unpack_path = os.Path.join(FGL_GETENV("TOP"),"unpack")
   LET l_tarname_path = os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname)
   LET l_tarname_file = os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname||".tar")

   # 若是不先進到tar檔所在目錄，在解tar時會產生在程式執行時的當下目錄
   IF os.Path.chdir(l_tarname_path) THEN
      LET l_cmd = "tar xvf ",os.Path.join(l_tarname_path,g_tarname||"_source.tar")
      RUN l_cmd
   ELSE
      LET l_cmd = "change directory error"
      CALL cl_err(l_cmd,"!",1)
   END IF
   # No:FUN-A90064 --- end ---
 
   #備份整個PATCH中程序資料
   # No:FUN-A90064 ---start---
   LET l_back_file = g_tarname CLIPPED,".bak"
   LET l_file = os.Path.join(os.Path.join(FGL_GETENV("TEMPDIR"),l_back_file),"recover.tar")
   CALL os.Path.exists(l_file) RETURNING li_result
   # No:FUN-A90064 --- end ---
   IF NOT li_result THEN    # 如果沒找到 
      CALL file_backup()
   END IF 
   
   #選取的單號對應的程序資料 
   CALL g_show_msg_curr.clear()                                                                                              
   FOR l_ac = 1 TO tm.getlength()                                                                                           
      IF tm[l_ac].select = 'Y'  THEN                                                                                          
         CALL update_list(tm[l_ac].zl08)                                                                                                  
      END IF                                                                                                                 
   END FOR
   #如果沒有單號選出則直接退出
   IF g_show_msg_curr.getLength() = 0 THEN 
      LET g_quit = "Y"
      RETURN
   END IF   
 
   LET l_record_file = os.Path.join(FGL_GETENV("TEMPDIR"),"cptemp1.tmp")    # No:FUN-A90064
   LET l_record_file2 = os.Path.join(FGL_GETENV("TEMPDIR"),"cptemp2.tmp")   # No:FUN-A90064
   FOR l_i = 1 TO g_show_msg_curr.getlength()
      IF g_show_msg_curr[l_i].syc05="程式" AND g_show_msg_curr[l_i].zln03 NOT MATCHES "w*" THEN   # No:FUN-C20069
         LET l_string = g_show_msg_curr[l_i].syc06
 
         #TQC-7B0110  --start--
         IF os.Path.extension(l_string) = 'per' THEN
            # modify by No:FUN-A90064 ---start---
         #  IF os.Path.chdir(l_tarname_path) THEN
               LET l_syc06 = os.Path.rootname(l_string),".4fd"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
           
               LET l_syc06 = os.Path.rootname(l_string),".sdd"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
         #  ELSE
         #     LET l_cmd = "change directory error"
         #     CALL cl_err(l_cmd,"!",1)
         #  END IF
            # modify by No:FUN-A90064 --- end ---
         END IF
 
         #FUN-860059---add----str---
         #行業別
         IF os.Path.extension(os.Path.rootname(l_string)) = 'src' THEN
            # modify by No:FUN-A90064 ---start---
         #  IF os.Path.chdir(l_tarname_path) THEN
               LET l_string1= os.Path.rootname(os.Path.rootname(l_string))
               LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'_icd.4gl'
               LET l_syc06 = os.Path.basename(l_string)
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
            
               LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'_slk.4gl'
               LET l_syc06 = os.Path.basename(l_string)
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
            
               LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'.4gl'
               LET l_syc06 = os.Path.basename(l_string)
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
         #  ELSE
         #     LET l_cmd = "change directory error"
         #     CALL cl_err(l_cmd,"!",1)
         #  END IF
            # modify by No:FUN-A90064 --- end ---
         END IF    
         #FUN-860059---add----end---

         # No:FUN-B60121 ---start---
         IF os.Path.extension(l_string) = '4rp' THEN
         #  IF os.Path.chdir(l_tarname_path) THEN
               LET l_syc06 = os.Path.rootname(l_string),"*.4rp"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd

               # No:FUN-B70023 ---start---
               LET l_syc06 = os.Path.rootname(l_string),"*.png"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
               # No:FUN-B70023 --- end ---
           
               LET l_syc06 = os.Path.rootname(l_string),".rdd"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd

               LET l_syc06 = os.Path.rootname(l_string),".sampledata"
               IF os.Path.separator() = "/" THEN
                  LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
               ELSE
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
               END IF
               RUN l_cmd
         #  ELSE
         #     LET l_cmd = "change directory error"
         #     CALL cl_err(l_cmd,"!",1)
         #  END IF
         END IF
         # No:FUN-B60121 --- end ---
 
         #TQC-820024 add-----str----
         #bn5自由路徑時的處理
         #ex:ds4gl2/fgldeb/fgldeb.42m 透過下面程式處理,l_string結果應為fgldeb.42m
         # No:FUN-A90064 ---start---
      #  LET l_row = 1
      #  WHILE l_string.getIndexOf('/',l_row)
      #     LET l_row = l_string.getIndexOf('/',l_row) + 1
      #     CONTINUE WHILE
      #  END WHILE
      #  LET l_string= l_string.subString(l_row,l_string.getLength())
      #  #TQC-820024 add-----end----
 
      #  LET l_syc06 = l_string
      #  #TQC-7B0110 ---end---

         LET l_syc06 = os.Path.basename(l_string)   # No:FUN-A90064
 
      #  IF os.Path.chdir(l_tarname_path) THEN
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_record_file
            ELSE
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_record_file
            END IF
            RUN l_cmd
      #  ELSE
      #     LET l_cmd = "change directory error"
      #     CALL cl_err(l_cmd,"!",1)
      #  END IF
         # No:FUN-A90064 --- end ---
      END IF
   END FOR  

   # No:FUN-A90064 ---start---
   LET l_i = 1
   LET lc_channel = base.Channel.create()
   IF os.Path.separator() = "/" THEN
      # 資料排序後排除重覆資料
      LET l_cmd = "sort ",l_record_file," | uniq -d >> ",l_record_file2
      RUN l_cmd
      LET l_cmd = "sort ",l_record_file," | uniq -u >> ",l_record_file2
      RUN l_cmd
      IF NOT os.Path.delete(l_record_file) THEN
         DISPLAY "delete ",l_record_file," was failed."
      END IF
 
      CALL lc_channel.openFile(l_record_file2,"r")
   ELSE
      # SQL SERVER無sort及uniq指令可供排序及排除重覆行資料
      # 因此決定就算有重覆資料也讓程式重覆覆蓋
      # 所以直接讀取檔案即可
      CALL lc_channel.openFile(l_record_file,"r")
   END IF

   WHILE lc_channel.read(ls_str)
      LET lc_str[l_i] = ls_str CLIPPED 
      LET l_i = l_i + 1  
   END WHILE
  
   CALL lc_channel.close()
   CALL lc_str.deleteElement(l_i)
             
   IF os.Path.separator() = "/" THEN
      LET l_cmd = "rm ",l_record_file2
      RUN l_cmd
   END IF
   # No:FUN-A90064 --- end ---
 
   #開始覆蓋程序
   FOR l_i = 1 TO lc_str.getLength()
      IF cl_null(lc_str[l_i]) THEN 
         CONTINUE FOR 
      ELSE   
         #TQC-C80051 -- add start --
         IF g_gay01 = "1" AND lc_str[l_i].getIndexOf("/4rp/1/",1) > 0 THEN   
            CONTINUE FOR
         ELSE
         #TQC-C80051 -- add end -- 
            LET l_row = 1   
            WHILE lc_str[l_i].getIndexOf(os.Path.separator(),l_row)
               LET l_row = lc_str[l_i].getIndexOf(os.Path.separator(),l_row) + 1
               CONTINUE WHILE
            END WHILE
            LET ld_str[l_i] = lc_str[l_i].subString(l_tarname_path.getLength()+2,l_row-1)
            LET lb_str[l_i] = lc_str[l_i].subString(l_row,lc_str[l_i].getLength())  
 
            # No:FUN-A90064 ---start---
            #TQC-840034----mod---str--
            # 沒有新目錄時,需新建目錄
            # No:FUN-BA0022 --start---
            # 建立目錄時無法一次建立多層，須一層一層建立
            # 從$TOP以下目錄開始檢查
            LET l_row = 1
            LET l_flag = TRUE
            LET l_file = os.Path.join(l_topdir,ld_str[l_i])
            WHILE l_file.getIndexOf(os.Path.separator(),l_row)
               LET l_row = l_file.getIndexOf(os.Path.separator(),l_row) + 1
               LET l_file1 = l_file.subString(1,l_row-2)
               IF l_file1.getLength() > l_topdir.getLength() THEN
                  IF NOT os.Path.exists(l_file1) THEN
                     CALL os.Path.mkdir(l_file1) RETURNING l_flag
                     IF NOT l_flag THEN
                        DISPLAY "directory ",l_file1," created failed."
                     END IF
                  END IF
               END IF
               CONTINUE WHILE
            END WHILE

            IF NOT l_flag THEN
               LET l_cmd = "directory ",l_file1," created failed."
               CALL cl_err(l_cmd,"!",1)
            END IF
            # No:FUN-BA0022 --- end ---
            #TQC-840034----mod---end--
       
            LET l_cmd = "mv  ",os.Path.join(l_tarname_path,lc_str[l_i])," ",l_file
            RUN l_cmd
            # No:FUN-A90064 --- end ---
         END IF    
      END IF   #TQC-C80051 add
   END FOR

   # No:FUN-A90064 ---start---
   LET l_source_file = os.Path.join(os.Path.join(l_tempdir,g_tarname||".bak"),"recover.tar")
   IF NOT os.Path.copy(l_source_file,os.Path.join(l_tarname_path,"recover.tar")) THEN
      DISPLAY "copy ",l_source_file," to ",l_tarname_path," was failed."
   END IF
   # No:FUN-A90064 --- end ---
 
   CALL cust_show()    
   #SHOW更新客戶標準區狀況
   IF g_link = 'Y' THEN
      DISPLAY "開始編譯和LINK程序！" 
      FOR l_ac = 1 TO g_show_msg_curr.getLength()
         LET l_row = lb_str[l_ac].getIndexOf('.',1)
         LET l_string = lb_str[l_ac].subString(l_row+1,lb_str[l_ac].getLength())
         LET la_str[l_ac] = lb_str[l_ac].subString(1,l_row-1)
         IF ld_str[l_ac] <> os.Path.join("ds4gl2","bin") THEN
            IF l_string = '4gl' AND (la_str[l_ac].subString(1,1) = 's' OR la_str[l_ac].subString(1,2) = 'cl' OR la_str[l_ac].subString(1,1) = 'q') THEN 
               # No:FUN-A90064 ---start---
               IF os.Path.chdir(ld_str[l_ac]) THEN
                  LET l_cmd = "r.c2 ",la_str[l_ac]
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",ld_str[l_ac]
               END IF
            END IF
         END IF 
      END FOR
      LET l_cmd = "r.gx lib"
      RUN l_cmd
      LET l_cmd = "r.gx sub"
      RUN l_cmd
      LET l_cmd = "r.gx qry"
      RUN l_cmd    
   END IF    

   LET l_i = 1
   FOR l_ac = 1 TO g_show_msg_curr.getLength()
      IF g_link = 'Y' THEN
         LET l_row = lb_str[l_ac].getIndexOf('.',1)
         LET l_string = lb_str[l_ac].subString(l_row+1,lb_str[l_ac].getLength())
         LET la_str[l_ac] = lb_str[l_ac].subString(1,l_row-1)
         IF ld_str[l_ac] <> os.Path.join("ds4gl2","bin") THEN
            IF l_string = '4gl' THEN 
               IF os.Path.chdir(ld_str[l_ac]) THEN
                  LET l_cmd = "r.c2 ",la_str[l_ac]
                  RUN l_cmd
                  LET l_cmd = "r.l2 ",la_str[l_ac]
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",ld_str[l_ac]
               END IF
            END IF 
            IF l_string = '4fd' OR l_string = 'per' THEN 
               IF os.Path.chdir(ld_str[l_ac]) THEN
                  LET l_cmd = "r.f2 ",la_str[l_ac]
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",ld_str[l_ac]
               END IF
            END IF 
         END IF    
      END IF
 
      IF g_show_msg_curr[l_ac].syc05 = '程式' THEN
         # 因為web區的程式patch包不會在這邊解，所以不需列出web區的程式清單出來
         IF g_show_msg_curr[l_ac].zln03 NOT MATCHES "w*" THEN   # No:FUN-C20069
            LET g_show_msg[l_i].cust  = g_show_msg_curr[l_ac].cust
            LET g_show_msg[l_i].syc01 = g_show_msg_curr[l_ac].syc01
            LET g_show_msg[l_i].syc03 = g_show_msg_curr[l_ac].syc03
            LET g_show_msg[l_i].syc05 = g_show_msg_curr[l_ac].syc05
            LET g_show_msg[l_i].syc06 = g_show_msg_curr[l_ac].syc06
            LET g_show_msg[l_i].syc07 = g_show_msg_curr[l_ac].syc07
            LET g_show_msg[l_i].syc08 = g_show_msg_curr[l_ac].syc08   # No:FUN-C20108
            LET g_show_msg[l_i].gaz03 = g_show_msg_curr[l_ac].gaz03
            LET ld_channel = base.Channel.create()
          
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",g_show_msg_curr[l_ac].syc06 CLIPPED,"`"
            ELSE
               LET l_cmd = "dir/s ",l_tarname_path,g_show_msg_curr[l_ac].syc06 CLIPPED
            END IF
            CALL ld_channel.openPipe(l_cmd,"r")
            LET l_flow[l_i] = ld_channel.readLine()
            IF cl_null(l_flow[l_i]) THEN         
               LET g_show_msg[l_i].pack_status = "成功"
            ELSE
               LET g_show_msg[l_i].pack_status = "失敗"
            END IF 
            CALL ld_channel.close()
            LET l_i = l_i + 1
         END IF
      ELSE
         LET g_show_msg[l_i].cust  = g_show_msg_curr[l_ac].cust                                                                      
         LET g_show_msg[l_i].syc01 = g_show_msg_curr[l_ac].syc01                                                                    
         LET g_show_msg[l_i].syc03 = g_show_msg_curr[l_ac].syc03                                                                    
         LET g_show_msg[l_i].syc05 = g_show_msg_curr[l_ac].syc05                                                                    
         LET g_show_msg[l_i].syc06 = g_show_msg_curr[l_ac].syc06                                                                    
         LET g_show_msg[l_i].syc07 = g_show_msg_curr[l_ac].syc07
         LET g_show_msg[l_i].syc08 = g_show_msg_curr[l_ac].syc08   # No:FUN-C20108
         LET g_show_msg[l_i].gaz03 = g_show_msg_curr[l_ac].gaz03
 
         LET l_cnt = 0
         LET l_cnt2 =0 #TQC-BB0113 add
         LET le_channel = base.Channel.create()
 
         IF os.Path.separator() = "/" THEN
            LET l_cmd = "grep -i 'error' ",l_tarname_path CLIPPED,"/load.log | grep -i '",g_show_msg[l_i].syc05 CLIPPED,"' | grep -i '",g_show_msg[l_i].syc06 CLIPPED,"'"   #TQC-8A0015--081008--mod--by mandy
         ELSE
            LET l_cmd = os.Path.join(l_tarname_path,"load.log")
         END IF
 
         CALL le_channel.openPipe(l_cmd,"r")
         WHILE(le_channel.read(l_flow[l_i]))
            IF os.Path.separator() = "/" THEN
               LET l_cnt = l_cnt + 1
            ELSE
               LET l_str = "error"
               IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                  LET l_str = g_show_msg[l_i].syc05
                  IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                     LET l_str = g_show_msg[l_i].syc06
                     IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                        LET l_cnt = l_cnt + 1
                     END IF
                  END IF
               END IF
            END IF
         END WHILE
         #TQC-BB0113 --add start--
         IF os.Path.separator() = "/" THEN
            LET l_cmd = "grep -i 'exists' ",l_tarname_path CLIPPED,"/load.log | grep -i '",g_show_msg[l_i].syc05 CLIPPED,"' | grep -i '",g_show_msg[l_i].syc06 CLIPPED,"'"   #TQC-8A0015--081008--mod--by mandy
         ELSE
            LET l_cmd = os.Path.join(l_tarname_path,"load.log")
         END IF
         CALL le_channel.openPipe(l_cmd,"r")
         WHILE(le_channel.read(l_flow[l_i]))
            IF os.Path.separator() = "/" THEN
               LET l_cnt2 = l_cnt2 + 1
            ELSE
               LET l_str = "exists"
               IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                  LET l_str = g_show_msg[l_i].syc05
                  IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                     LET l_str = g_show_msg[l_i].syc06
                     IF l_flow[l_i].getIndexOf(l_str.toLowerCase(),1) > 0 THEN
                        LET l_cnt2 = l_cnt2 + 1
                     END IF
                  END IF
               END IF
            END IF
         END WHILE
         #TQC-BB0113 --add end--
         IF l_cnt = 0 THEN      
            IF l_cnt2 = 0 THEN	  #TQC-BB0113 --add
               LET g_show_msg[l_i].pack_status = "成功"
            #TQC-BB0113 --add start--
         ELSE
            LET g_show_msg[l_i].pack_status = "未更新" 
            END IF
	    #TQC-BB0113 --add end--
		 ELSE
            LET g_show_msg[l_i].pack_status = "失敗"
         END IF
         CALL le_channel.close()
         LET l_i = l_i + 1
      END IF
   END FOR
 
   # No:FUN-A90064 ---start---
   IF os.Path.chdir(l_tempdir) THEN
      #FUN-860102
      IF cl_null(g_argv1) THEN      
         #FUN-860102
         LET g_max_rec_o = g_max_rec    #CHI-8C0021
      #  LET g_max_rec   = 3000         #CHI-8C0021 
         LET g_max_rec   = g_show_msg.getLength()        # No:FUN-A90064
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),'更新客戶標準區狀況,請自行轉存excel存檔','客制否|單號|動作|程式或資料|KEY值欄位1|KEY值欄位2|備註1|備註2|更新標準區狀況')  
         CALL p_unpack2_show_array(base.TypeInfo.create(g_show_msg),'更新客戶標準區狀況,請自行轉存excel存檔','客制否|單號|動作|程式或資料|KEY值欄位1|KEY值欄位2|備註1|備註2|更新標準區狀況')
         CALL os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)) RETURNING ls_cnt   #TQC-C30059 add
         IF ls_cnt THEN  #TQC-C30059 表示有找到
            LET l_cmd = "mv ",os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"清單相關資訊.xls")
            RUN l_cmd 
         END IF    #TQC-C30059 
         LET g_max_rec   = g_max_rec_o  #CHI-8C0021
         IF INT_FLAG = 1 THEN
            LET INT_FLAG = 0
         END IF
      END IF  #FUN-860102
   ELSE
      DISPLAY "Error: Cannot change to ",l_tempdir
      LET l_cmd = "Error: Cannot change to ",l_tempdir
      CALL cl_err(l_cmd,"!",1)
   END IF
   # No:FUN-A90064 --- end ---
   # No:TQC-BB0216 --- add ---
  #LET l_cmd = "mv ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_list.xls")," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"alter_list.xls")
  #RUN l_cmd
  #LET l_cmd = "mv ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"清單相關資訊.xls")," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"清單相關資訊.xls")
  #RUN l_cmd
   LET l_err_xls = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_ERR_list.xls")
   CALL os.Path.exists(l_err_xls) RETURNING ls_cnt
   IF ls_cnt THEN
      LET l_cmd = "mv ",l_err_xls," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"alter_ERR_list.xls")
      RUN l_cmd 
   END IF
   # No:TQC-BB0216 --- end ---
   #move .tar to unpack
   LET l_cmd = " mv ",l_tarname_file," ",l_unpack_path
   RUN l_cmd
   IF os.Path.separator() = "/" THEN
      LET l_cmd = "cp -rf ",l_tarname_path,"  ",l_unpack_path
      RUN l_cmd
      LET l_cmd = "rm -rf ",l_tarname_path
      RUN l_cmd
   ELSE
      LET l_cmd = "mv ",l_tarname_path,"  ",l_unpack_path
      RUN l_cmd
   END IF
 
   DISPLAY "==============程序中產生的文檔================="       
   LET l_file = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"delete.log")
   IF os.Path.exists(l_file) THEN
      DISPLAY "請查看文件   :",l_file
   END IF
   DISPLAY "請查看文件    :",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"load.log")
   DISPLAY "請查看文件    :",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"Success.log")
   IF g_db_type = "ORA" THEN 
      DISPLAY "數據庫備份文件:",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"exp_dssys.dmp")
   ELSE 
      DISPLAY "數據庫備份文件:",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"dssys.exp")
   END IF   	  
   DISPLAY "程序備份文件  :",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"recover.tar")
   CALL os.Path.dirsort("name",1)
   LET l_h = os.Path.diropen(os.Path.join(l_unpack_path,g_tarname))
   WHILE l_h > 0
      LET l_file = os.Path.dirnext(l_h)
      IF l_file IS NULL THEN
         EXIT WHILE
      END IF
      IF l_file = "." OR l_file = ".." THEN
         CONTINUE WHILE
      END IF

      IF os.Path.extension(l_file) = "exe" THEN
         LET l_idx = l_file.getIndexOf("_CR.exe",1)
         IF l_idx > 0 THEN
            DISPLAY "請將此CR報表檔放到CR主機解壓  :",os.Path.join(os.Path.join(l_unpack_path,g_tarname),l_file)
         END IF
      END IF
   END WHILE
   #TQC-BB0216 -- add start --
   LET l_file =os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"alter_list.xls")
   CALL os.Path.exists(l_file) RETURNING ls_cnt
   IF ls_cnt THEN
      DISPLAY "Alter 清單文件: ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"alter_list.xls")             
   END IF
   DISPLAY "清單資訊相關文件: ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"清單相關資訊.xls")        
   LET l_err_xls = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"unpack"),g_tarname),"alter_ERR_list.xls")
   CALL os.Path.exists(l_err_xls) RETURNING ls_cnt
   IF ls_cnt THEN
      DISPLAY "Alter時發生錯誤清單: ",l_err_xls    
   END IF
   #TQC-BB0216 -- add end --
   CALL os.Path.dirclose(l_h)
END FUNCTION
 
 
FUNCTION file_backup()
   DEFINE l_cmd        STRING
   DEFINE l_date       LIKE type_file.chr6
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ac         LIKE type_file.num5
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE l_tempdir    STRING
   DEFINE l_topdir     STRING
   DEFINE l_str        STRING
   DEFINE ls_str       STRING
   DEFINE lc_channel   base.Channel
   DEFINE ld_channel   base.Channel
   DEFINE le_channel   base.Channel
   DEFINE l_row        LIKE type_file.num5
   DEFINE lc_str       DYNAMIC ARRAY OF STRING
   DEFINE ld_str       DYNAMIC ARRAY OF STRING
   DEFINE l_flow       DYNAMIC ARRAY OF STRING
   DEFINE lp_str       DYNAMIC ARRAY OF STRING
   DEFINE ln_str       DYNAMIC ARRAY OF STRING
   DEFINE l_string     STRING
   DEFINE l_string1    STRING #FUN-860059 add
   DEFINE l_syc06      LIKE type_file.chr100   # No:FUN-C90054
   DEFINE l_rowcnt     LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_tarname_path   STRING     # No:FUN-A90064
   DEFINE l_file           STRING     # No:FUN-A90064
   DEFINE l_result         STRING     # No:FUN-A90064
   DEFINE l_record_file    STRING     # No:FUN-A90064
   DEFINE l_record_file2   STRING     # No:FUN-A90064
       
 
   LET l_date = TODAY USING "yymmdd"
   LET l_topdir =FGL_GETENV('TOP')
   LET l_tempdir=FGL_GETENV('TEMPDIR')
   LET l_tarname_path = os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname)   # No:FUN-A90064
   
   CALL g_show_msg_curr.clear()                                                                                              
   FOR l_ac = 1 TO tm.getlength()                                                                                                                                                                                     
      CALL update_list(tm[l_ac].zl08)                                                                                                                                                                                                                  
   END FOR
 
   FOR l_i = 1 TO g_show_msg_curr.getlength()
      IF g_show_msg_curr[l_i].syc05="程式" AND g_show_msg_curr[l_i].zln03 NOT MATCHES "w*" THEN   # No:FUN-C20069
         LET l_string = g_show_msg_curr[l_i].syc06
 
         LET l_file = os.Path.join(l_tempdir,"cptemp3.tmp")   # No:FUN-A90064
         #TQC-7B0110 --start--          
         IF os.Path.extension(l_string) = 'per' THEN 
            LET l_syc06 = os.Path.rootname(l_string),".4fd"
            # No:FUN-A90064 ---start---
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
               RUN l_cmd
            ELSE
            #  IF os.Path.chdir(l_tarname_path) THEN
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
                  RUN l_cmd
            #  ELSE
            #     DISPLAY "Error: Cannot change to ",l_tarname_path
            #  END IF
            END IF

            LET l_syc06 = os.Path.rootname(l_string),".sdd"
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
               RUN l_cmd
            ELSE
            #  IF os.Path.chdir(l_tarname_path) THEN
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
                  RUN l_cmd
            #  ELSE
            #     DISPLAY "Error: Cannot change to ",l_tarname_path
            #  END IF
            END IF
            # No:FUN-A90064 --- end ---
         END IF
 
         #TQC-850040          
         IF os.Path.extension(os.Path.rootname(l_string)) = 'src' THEN 
            LET l_string1= os.Path.rootname(os.Path.rootname(l_string))             #FUN-860059 add
            LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'_icd.4gl' #FUN-860059 mod
            LET l_syc06 = os.Path.basename(l_string)
            # No:FUN-A90064 ---start---
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
               RUN l_cmd
            ELSE
            #  IF os.Path.chdir(l_tarname_path) THEN
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
                  RUN l_cmd
            #  ELSE
            #     DISPLAY "Error: Cannot change to ",l_tarname_path
            #  END IF
            END IF

            LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'_slk.4gl' #FUN-860059 mod
            LET l_syc06 = os.Path.basename(l_string)
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
               RUN l_cmd
            ELSE
               IF os.Path.chdir(l_tarname_path) THEN
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",l_tarname_path
               END IF
            END IF

            LET l_string = os.Path.rootname(os.Path.rootname(l_string1)),'.4gl'     #FUN-860059 mod
            LET l_syc06 = os.Path.basename(l_string)
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
               RUN l_cmd
            ELSE
               IF os.Path.chdir(l_tarname_path) THEN
                  LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",l_tarname_path
               END IF
            END IF
            # No:FUN-A90064 --- end ---
         END IF

         # No:FUN-B60121 ---start---
         IF os.Path.extension(l_string) = '4rp' THEN
            LET l_syc06 = os.Path.rootname(l_string),"*.4rp"
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
            ELSE
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
            END IF
            RUN l_cmd

            # No:FUN-B70023 ---start---
            LET l_syc06 = os.Path.rootname(l_string),"*.png"
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
            ELSE
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
            END IF
            RUN l_cmd
            # No:FUN-B70023 --- end ---
           
            LET l_syc06 = os.Path.rootname(l_string),".rdd"
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
            ELSE
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
            END IF
            RUN l_cmd

            LET l_syc06 = os.Path.rootname(l_string),".sampledata"
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
            ELSE
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
            END IF
            RUN l_cmd
         END IF
         # No:FUN-B60121 --- end ---

         LET l_syc06 = os.Path.basename(l_string)
         # No:FUN-A90064 ---start---
         IF os.Path.separator() = "/" THEN
            LET l_cmd = "find ",l_tarname_path," -name `basename ",l_syc06 CLIPPED ,"`  >> ",l_file
            RUN l_cmd
         ELSE
         #  IF os.Path.chdir(l_tarname_path) THEN
               LET l_cmd = "dir/s ",l_syc06 CLIPPED ,"  >> ",l_file
               RUN l_cmd
         #  ELSE
         #     DISPLAY "Error: Cannot change to ",l_tarname_path
         #  END IF
         END IF
         # No:FUN-A90064 --- end ---
 
         #TQC-850040                    
         #TQC-7B0110 ---end---     
      END IF
   END FOR  

   # No:FUN-A90064 ---start---
   LET l_i = 1
   LET lc_channel = base.Channel.create()
   LET l_record_file = os.Path.join(l_tempdir,"cptemp3.tmp")
   LET l_record_file2 = os.Path.join(l_tempdir,"cptemp4.tmp")
   IF os.Path.separator() = "/" THEN
      # 資料排序後排除重覆資料
      LET l_cmd = "sort ",l_record_file," | uniq -d >> ",l_record_file2
      RUN l_cmd
      LET l_cmd = "sort ",l_record_file," | uniq -u >> ",l_record_file2
      RUN l_cmd
      IF NOT os.Path.delete(l_record_file) THEN
         DISPLAY "delete ",l_record_file," was failed."
      END IF
 
      CALL lc_channel.openFile(l_record_file2,"r")
   ELSE
      # SQL SERVER無sort及uniq指令可供排序及排除重覆行資料
      # 因此決定就算有重覆資料也讓程式重覆覆蓋
      # 所以直接讀取檔案即可
      CALL lc_channel.openFile(l_record_file,"r")
   END IF

   WHILE lc_channel.read(ls_str)
      LET lc_str[l_i] = ls_str CLIPPED 
      LET l_i = l_i + 1  
   END WHILE
  
   CALL lc_channel.close()
   CALL lc_str.deleteElement(l_i)
             
   IF os.Path.separator() = "/" THEN
      LET l_cmd = "rm ",l_record_file2
      RUN l_cmd
   END IF
   # No:FUN-A90064 --- end ---

   #若沒有備份，首先建立目錄
   LET l_file = os.Path.join(l_tempdir,g_tarname||".bak")
   IF NOT os.Path.exists(l_file) THEN
      CALL os.Path.mkdir(l_file) RETURNING l_result
      IF NOT l_result THEN
         DISPLAY l_file," create failed."
      END IF
   END IF

   FOR l_i = 1 TO lc_str.getLength()
      IF cl_null(lc_str[l_i]) THEN 
         CONTINUE FOR            
      ELSE    
         #TQC-7B0110 --start--              	
         LET l_row = 1   
         WHILE lc_str[l_i].getIndexOf(os.Path.separator(),l_row)
            LET l_row = lc_str[l_i].getIndexOf(os.Path.separator(),l_row) + 1
            CONTINUE WHILE
         END WHILE
         # No:FUN-A90064 ---start---
      #  LET lp_str[l_i] = lc_str[l_i].subString(3,l_row-2)
         LET lp_str[l_i] = lc_str[l_i].subString(l_tarname_path.getLength()+2,l_row-2)
         LET ln_str[l_i] = lc_str[l_i].subString(l_tarname_path.getLength()+2,lc_str[l_i].getLength())
         IF os.Path.chdir(l_file) THEN
            IF os.Path.separator() = "/" THEN
               LET l_cmd = "mkdir -p ",lp_str[l_i] CLIPPED
               RUN l_cmd
               IF os.Path.chdir(l_topdir) THEN
                  LET l_cmd = "cp  ",os.Path.join(l_topdir,ln_str[l_i])," ",os.Path.join(l_file,lp_str[l_i])
                  RUN l_cmd
               ELSE
                  DISPLAY "Error: Cannot change to ",l_topdir
               END IF
            ELSE
               LET l_cmd = "mkdir ",lp_str[l_i] CLIPPED
               RUN l_cmd
               IF os.Path.chdir(l_topdir) THEN
                  CALL os.Path.copy(ln_str[l_i],os.Path.join(l_file,lp_str[l_i])) RETURNING l_result
                  IF NOT l_result THEN
                     DISPLAY "copy ",os.Path.join(l_topdir,ln_str[l_i])," to ",os.Path.join(l_file,lp_str[l_i])," failed."
                  END IF
               ELSE
                  DISPLAY "Error: Cannot change to ",l_topdir
               END IF
            END IF
         ELSE
            DISPLAY "Error: Cannot change to ",l_file
         END IF
         # No:FUN-A90064 --- end ---
         #TQC-7B0110 ---end---
      END IF   
   END FOR
   IF os.Path.chdir(l_file) THEN
      LET l_cmd = "tar cvf recover.tar * "
      RUN l_cmd
   ELSE
      DISPLAY "Error: Cannot change to ",l_file
   END IF
END FUNCTION         
 
#No.FUN-830034 --start--
FUNCTION p_unpack2_bpatch()
   DEFINE   ls_toppath   STRING
   DEFINE   ls_cmd       STRING
   DEFINE   ls_path      STRING     # No:FUN-A90064
 
   LET ls_toppath = FGL_GETENV("TOP")
   IF g_patchname.getIndexOf(".tar",1) > 1 THEN
      LET g_patchname = g_patchname.subString(1,g_patchname.getIndexOf(".tar",1)-1)
   END IF
   LET ls_path = os.Path.join(ls_toppath,"pack")
   IF os.Path.exists(ls_toppath||os.Path.separator()||"pack"||g_patchname) THEN
      IF cl_confirm("azz-765") THEN
         MESSAGE "Unzipping...Please Wait"
         IF os.Path.chdir(ls_path) THEN
            LET ls_cmd = "tar xvf ",g_patchname,".tar"
            RUN ls_cmd
         ELSE
            DISPLAY "Error: Cannot change to ",ls_path
         END IF
      END IF
   ELSE
      MESSAGE "Unzipping...Please Wait"
      IF os.Path.chdir(ls_path) THEN
         LET ls_cmd = "tar xvf ",g_patchname,".tar"
         RUN ls_cmd
      ELSE
         DISPLAY "Error: Cannot change to ",ls_path
      END IF
   END IF

   LET ls_path = os.Path.join(os.Path.join(ls_toppath,"pack"),g_patchname)
   IF cl_db_get_database_type() = "ORA" THEN
      IF os.Path.chdir(ls_path) THEN
         IF os.Path.separator() = "/" THEN
            LET ls_cmd = ". modify_fglprofile.sh"
            RUN ls_cmd
            LET ls_cmd = "$FGLRUN bpatch_patch ",g_patchname
            RUN ls_cmd
         END IF
      ELSE
         DISPLAY "Error: Cannot change to ",ls_path
      END IF
   ELSE
      IF os.Path.chdir(ls_path) THEN
         IF os.Path.separator() = "/" THEN
            LET ls_cmd = "$FGLRUN bpatch_patch ",g_patchname
            RUN ls_cmd
         END IF
      ELSE
         DISPLAY "Error: Cannot change to ",ls_path
      END IF
   END IF
END FUNCTION
#No.FUN-830034 ---end---
 
 
# No.FUN-970083 ---start---
FUNCTION p_unpack2_alter_db(l_kind)
   DEFINE l_sql            STRING
   DEFINE ls_cnt           LIKE type_file.num5
   DEFINE ls_i             LIKE type_file.num5
   DEFINE ls_db_file       STRING
   DEFINE ls_db_dir        STRING
   DEFINE ls_dbbackup_dir  STRING                  #TQC-BB0216 
   DEFINE l_cmd            STRING
   DEFINE l_str            STRING
   DEFINE li_result        LIKE type_file.num5
   DEFINE li_result_final  LIKE type_file.num5
   DEFINE li_cnt           LIKE type_file.num5
   DEFINE li_i             LIKE type_file.num5
   DEFINE li_k             LIKE type_file.num5
   DEFINE li_azp03         DYNAMIC ARRAY OF LIKE azp_file.azp03
  #DEFINE l_total_cnt      LIKE type_file.num5    # No:FUN-A90064   #TQC-BB0134 mark
   DEFINE l_kind           LIKE type_file.chr1    # No:FUN-C20069
                                              # l_kind代表意義：
                                              # --> l_kind = "1"   表示ds與wds都有alter的狀況
                                              # --> l_kind = "2"   表示ds有alter但wds沒有alter
                                              # --> l_kind = "3"   表示ds沒有alter但wds有alter
                                              # --> l_kind = "4"   表示ds與wds都沒有alter的狀況
   DEFINE l_err            INTEGER            # TQC-BB0216 -- add
   DEFINE l_ds4gl_path     STRING             # TQC-BB0216 -- add
   DEFINE l_tempdir        STRING
   #TQC-C30110 -- add start -- #比對是否於$FGLPROFILE Mark
   DEFINE l_ac             LIKE type_file.num5
   DEFINE l_dblist         DYNAMIC ARRAY OF RECORD
                            alter_chk    LIKE type_file.chr1,
                            backup_chk   LIKE type_file.chr1,
                            azp03        LIKE azp_file.azp03,
                            type         LIKE type_file.chr1
                           END RECORD
   DEFINE l_channel        base.Channel
   DEFINE l_profile_str    STRING
   DEFINE l_idx            LIKE type_file.num5
   DEFINE l_idx2           LIKE type_file.num5
   DEFINE l_zpa03          STRING
   DEFINE l_fglpro         STRING
   #TQC-C30110 -- add end -- #比對是否於$FGLPROFILE Mark
   
   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET l_ds4gl_path = FGL_GETENV('DS4GL')     # TQC-BB0216 -- add
   LET ls_db_dir = os.Path.join(os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup"),g_tarname)
   LET ls_dbbackup_dir = os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup") 
   LET li_result_final = TRUE

   # No:FUN-C20069 ---start---
   # 若是ds與wds都沒有alter則不需再往下進行
   IF l_kind = "4" THEN
      RETURN li_result_final
   END IF
   # No:FUN-C20069 --- end ---

   LET ls_i = 0
 
  #IF cl_prompt(0,0,"是否要自動執行 alter table 動作？") THEN   # TQC-BB0216 -- mark
      # 尋找TIPTOP DB
      # 確認azp_file中所記錄的DB是否都實際存在
      # 但informix資料庫因 ds與sysmaster未建立連線，所以無法直接select，需將sql語法拆開處理

      # No:FUN-A50044
      # 1.因為加了DISTINCT用法，所以無法於select時就先給"N"的預設值，
      #   故將此動作改於FOREACH中再給值
      # 2.dsall資料庫也一定要勾選，且須在虛擬資料庫alter前就先alter dsall資料庫
      #   因為虛擬資料庫是參考dsall的
     #LET l_sql = "SELECT 'N',azp03 FROM azp_file WHERE azp053 = 'Y' AND azp03 <> 'ds' ",
     #LET l_sql = "SELECT DISTINCT(azp03) FROM azp_file WHERE azp053 = 'Y' ",   # No:FUN-A50044
     #              " AND azp03 NOT IN ('ds','dsall')",   # No:FUN-A50044
     #              " AND UPPER(azp03) IN (SELECT username FROM all_users) ",
     #            " ORDER BY azp03"
      LET l_sql = "SELECT DISTINCT azw09 FROM azw_file",
                  " inner join all_users on username = UPPER(azw09)",
                  " WHERE azw09 <> 'ds'"
      DECLARE p_unpack2_ora_sel_db CURSOR FROM l_sql
      CALL g_dblist.clear()
     #LET l_total_cnt = 0   #TQC-BB0134 mark
      LET g_cnt = 1

      # No:FUN-C20069 ---start---
      # 1.若有alter table，ds資料庫應該要先做
      # 2.wds有可能會獨立alter，所以若ds未alter但wds有alter，仍需繼續進行
      # 3.若ds未alter，則其他DB(包含ods)都不需alter
      # l_kind代表意義：
      # --> l_kind = "1"   表示ds與wds都有alter的狀況
      # --> l_kind = "2"   表示ds有alter但wds沒有alter
      # --> l_kind = "3"   表示ds沒有alter但wds有alter
      # --> l_kind = "4"   表示ds與wds都沒有alter的狀況
      IF l_kind = "1" OR l_kind = "2" THEN
        #LET g_dblist[g_cnt].chk = "Y"             # TQC-BB0216 -- mark
         LET g_dblist[g_cnt].alter_chk = "Y"       # TQC-BB0216 -- add
         LET g_dblist[g_cnt].backup_chk = "Y"      # TQC-BB0216 -- add
         LET g_dblist[g_cnt].azp03 = "ds"
         LET g_dblist[g_cnt].type = "1"    # 表ds資料庫
         LET g_cnt = g_cnt + 1

         # No:FUN-C20069 ---start---
         # 若wds資料庫有做alter，則需要列在清單上，而且預設一定要勾選
         IF l_kind = "1" THEN   
           #LET g_dblist[g_cnt].chk = "Y"          # TQC-BB0216 -- mark
            LET g_dblist[g_cnt].alter_chk = "Y"    # TQC-BB0216 -- add
            LET g_dblist[g_cnt].backup_chk = "Y"   # TQC-BB0216 -- add                   
            LET g_dblist[g_cnt].azp03 = "wds"
            LET g_dblist[g_cnt].type = "6"       # 表wds資料庫
            LET g_cnt = g_cnt + 1
         END IF
         # No:FUN-C20069 --- end ---

         # No:FUN-A50044
         # 1.HIKO希望在列DB清單的時候，將法人DB及法人DB下所屬的DB視為一個Group，可以一起列出，
         #   因此需要先取出法人DB後，再去檢查此DB下有沒有其他DB，如果有就要一併列出，
         #   所以會先用一個暫存ARRAY去儲存法人DB，再去檢查其下有無其他DB
         # 2.type欄位主要是在記錄該DB的屬性，
         #   分類如下：1:ds  2:法人DB  3:法人DB下所屬的DB  4:虛擬DB  5:ods資料庫  6.wds資料庫
     
         LET li_k = 1
         FOREACH p_unpack2_ora_sel_db INTO g_dblist_pre[li_k].azp03
            IF g_dblist_pre[li_k].azp03 = "ds" THEN
               CONTINUE FOREACH
            ELSE
               # No:FUN-A50044 ---start---
               # aooi901中有記錄的DB都需要做alter動作(aooi931與aooi901中記錄的DB應為一致才對)
               # 且除了DS及法人DB外，其他DB預設不勾選
              #LET g_dblist[g_cnt].chk = "Y"            # TQC-BB0216 -- mark
               LET g_dblist[g_cnt].alter_chk = "Y"      # TQC-BB0216 -- add           
               LET g_dblist[g_cnt].backup_chk = "Y"     # TQC-BB0216 -- add               
               LET g_dblist[g_cnt].azp03 = g_dblist_pre[li_k].azp03 CLIPPED
               LET g_dblist[g_cnt].type = "2"           # 表法人DB
               LET g_cnt = g_cnt + 1
     
               # 找法人DB下所屬的DB清單
               LET li_i = 0
               SELECT COUNT(*) INTO li_i FROM azw_file
                inner join all_users on username = UPPER(azw05)
                WHERE azw05 = azw06
                  AND azw05 <> azw09
                  AND azw09 = g_dblist_pre[li_k].azp03
     
               IF li_i > 0 THEN
                  LET l_sql = "SELECT DISTINCT azw05 FROM azw_file",
                              " inner join all_users on username = UPPER(azw05)",
                              " WHERE azw05 = azw06",
                                " AND azw05 <> azw09",
                                " AND azw09 = '",g_dblist_pre[li_k].azp03 CLIPPED,"'"
                  DECLARE p_unpack2_ora_sel_db_2 CURSOR FROM l_sql
                  FOREACH p_unpack2_ora_sel_db_2 INTO g_dblist[g_cnt].azp03
                    #LET g_dblist[g_cnt].chk = "N"              # TQC-BB0216 -- mark
                     LET g_dblist[g_cnt].alter_chk = "N"        # TQC-BB0216 add
                     LET g_dblist[g_cnt].backup_chk = "N"       # TQC-BB0216 add                     
                     LET g_dblist[g_cnt].type = "3"     # 表法人DB下所屬的DB 
                     LET g_cnt = g_cnt + 1
                  END FOREACH
                  CALL g_dblist.deleteElement(g_cnt)
               END IF
     
               # 找虛擬DB
               LET li_i = 0
               SELECT COUNT(*) INTO li_i FROM azw_file
                inner join all_users on username = UPPER(azw06)
                WHERE azw05 <> azw06
                  AND azw09 = g_dblist_pre[li_k].azp03
     
               IF li_i > 0 THEN
                  LET l_sql = "SELECT DISTINCT azw06 FROM azw_file",
                              " inner join all_users on username = UPPER(azw06)",
                              " WHERE azw05 <> azw06",
                                " AND azw09 = '",g_dblist_pre[li_k].azp03 CLIPPED,"'"
                  DECLARE p_unpack2_ora_sel_db_3 CURSOR FROM l_sql
                  FOREACH p_unpack2_ora_sel_db_3 INTO g_dblist[g_cnt].azp03
                    #LET g_dblist[g_cnt].chk = "N"                # TQC-BB0216 Mark
                     LET g_dblist[g_cnt].alter_chk = "N"          # TQC-BB0216 add
                     LET g_dblist[g_cnt].backup_chk = "N"         # TQC-BB0216 add      
                     LET g_dblist[g_cnt].type = "4"           # 表虛擬DB
                     LET g_cnt = g_cnt + 1
                  END FOREACH
                  CALL g_dblist.deleteElement(g_cnt)
               END IF
     
               # No:FUN-A80074 ---mark start---
            #  # 若非標準資料庫(ds、ds1~ds6)，不自動作alter table動作
            #  IF g_dblist[g_cnt].azp03 NOT MATCHES 'ds[123456]' THEN
            #     CONTINUE FOREACH
            #  END IF
               # No:FUN-A80074 --- mark end ---
               # No:FUN-A50044 --- end ---
            END IF
     
            LET li_k = li_k + 1
         END FOREACH
         CALL g_dblist.deleteElement(g_cnt)
         # No:FUN-C20069 --- end ---
     
         # 因直接取ARRAY的長度會多取到一筆null的資料，
         # 因此改為delete掉多餘的一筆之後，馬上將ARRAY長度塞到一個變數裡面去記錄
      #  LET l_total_cnt = g_dblist.getLength()   # 2012/02/24 test

      ELSE           # ds資料庫未alter但wds有alter
        #LET g_dblist[g_cnt].chk = "Y"            # TQC-BB0216 mark
         LET g_dblist[g_cnt].alter_chk = "Y"	  # TQC-BB0216 add
         LET g_dblist[g_cnt].backup_chk = "Y"	  # TQC-BB0216 add         
         LET g_dblist[g_cnt].azp03 = "wds"
         LET g_dblist[g_cnt].type = "6"    # 表wds資料庫
         LET g_cnt = g_cnt + 1
      #  LET l_total_cnt = g_dblist.getLength()   # 2012/02/24 test
      END IF
     
      #TQC-C30110 -- add start -- #比對是否於$FGLPROFILE Mark
      CALL l_dblist.clear()
      LET l_fglpro = FGL_GETENV('FGLPROFILE')
      FOR l_ac = 1 TO g_dblist.getLength()
         LET l_channel = base.Channel.create()
         CALL l_channel.openFile(l_fglpro,"r")
         WHILE l_channel.read(l_profile_str)
            LET l_zpa03 = '"',g_dblist[l_ac].azp03,'"'
            LET l_idx  = l_profile_str.getIndexOf(l_zpa03,1)
            LET l_idx2 = l_profile_str.getIndexOf("schema",1)   #TQC-CA0019 modify
            IF l_idx > 0 AND l_idx2 > 0 THEN
               IF l_profile_str.subString(1,3) = "#db" THEN
                  CALL g_dblist.deleteElement(l_ac)
                  LET l_ac = l_ac -1   #TQC-CA0019 add
                  EXIT WHILE           #TQC-CA0019 CONTINUE WHILE - > EXIT WHILE
               ELSE
                  LET l_dblist[l_ac].* = g_dblist[l_ac].*
                  CONTINUE WHILE
               END IF
            END IF
            IF l_channel.isEof() THEN EXIT WHILE END IF
         END WHILE
      END FOR
      CALL g_dblist.clear()
      FOR l_ac = 1 TO l_dblist.getLength()
         LET g_dblist[l_ac].* = l_dblist[l_ac].*
      END FOR
      #TQC-C30110 -- add end -- #比對是否於$FGLPROFILE Mark
   
      # 開窗讓使用者選擇資料庫
     #OPEN WINDOW db_w WITH FORM "azz/42f/p_unpack2_sel_db.42f"   # TQC-BB0216 mark
     #CALL cl_ui_locale("p_unpack2_sel_db")                       # TQC-BB0216 mark 
      
      # TQC-BB0216 --- add atart ---
      LET delete_chk = "N"
      OPEN WINDOW db_w WITH FORM "azz/42f/p_unpack2_sel_ab.42f" 		    
      CALL cl_ui_locale("p_unpack2_sel_ab")
      INPUT BY NAME g_pwd,g_pwd_sys,delete_chk WITHOUT DEFAULTS
         
         BEFORE INPUT
            CALL cl_set_comp_entry("g_pwd",TRUE)
            CALL cl_set_comp_entry("g_pwd_sys",TRUE)
            CALL cl_set_comp_entry("delete_chk",TRUE)
    
	 AFTER INPUT
            LET l_err = 1   
            LET l_cmd = "sh ",l_ds4gl_path,"/bin/patchtemp.sh ",g_pwd CLIPPED," ",g_pwd_sys CLIPPED," | tee  /tmp/patchtemp.chk"    
            RUN l_cmd                                                                                                              
            LET l_cmd = "grep 'Wrong passwd' /tmp/patchtemp.chk"                                                                            
            RUN l_cmd RETURNING l_err                                                                                              
            IF l_err = 0 THEN
               LET l_err = 1
               CALL cl_err("SYS、SYSTEM",'azz-865',1)
               NEXT FIELD g_pwd
            ELSE
               LET l_err = 0
            END IF
           
         ON CHANGE delete_chk
            IF delete_chk = "Y" THEN
               CALL p_unpack2_delete_patch_backup()
            END IF

         ON ACTION cancel
            CLEAR FROM
            CLOSE WINDOW db_w
            CALL g_dblist.clear()
           #RETURN li_result_final   #TQC-BB0216 mark
            RETURN 2                 #TQC-BB0216 add
         END INPUT

      INPUT ARRAY g_dblist WITHOUT DEFAULTS FROM s_azp03.*
         ATTRIBUTE(COUNT=g_dblist.getLength(),MAXCOUNT=g_dblist.getLength(),UNBUFFERED,
                   INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)

         # No:FUN-C20069 ---modify start---
      #  BEFORE FIELD chk
         ON ROW CHANGE
            IF g_dblist[ARR_CURR()].azp03 = "ds" OR g_dblist[ARR_CURR()].azp03 = "wds" THEN
              #IF g_dblist[ARR_CURR()].chk <> "Y" THEN               #TQC-BB0216 mark
               IF g_dblist[ARR_CURR()].alter_chk <> "Y" OR g_dblist[ARR_CURR()].backup_chk <> "Y" THEN         #TQC-BB0216 add
                 #LET g_dblist[ARR_CURR()].chk = "Y"                 #TQC-BB0216 mark
                  LET g_dblist[ARR_CURR()].alter_chk = "Y"           #TQC-BB0216 add 
                  LET g_dblist[ARR_CURR()].backup_chk = "Y"          #TQC-BB0216 add
                 #DISPLAY BY NAME g_dblist[ARR_CURR()].chk           #TQC-BB0216 mark
                  DISPLAY BY NAME g_dblist[ARR_CURR()].alter_chk     #TQC-BB0216 add         
                  LET l_cmd = "ds與wds若有alter預設一定要勾選"
                  CALL cl_err(l_cmd,"!",1)
                 #NEXT FIELD chk         #TQC-BB0216 mark
                  NEXT FIELD alter_chk   #TQC-BB0216 add
               END IF
            END IF
         # No:FUN-C20069 --- modify end ---
  
        ## No:FUN-A80074 ---start---
         ON ACTION alter_select_all                
            FOR li_k = 1 TO g_dblist.getLength()
           #FOR li_k = 1 TO l_total_cnt   #TQC-BB0134 mark
               LET g_dblist[li_k].alter_chk = "Y"
            END FOR

         ON ACTION alter_cancel_all  
            FOR li_k = 1 TO g_dblist.getLength()
           #FOR li_k = 1 TO l_total_cnt   #TQC-BB0134 mark 
              # ds與wds資料庫若有alter一定要選 
              CASE
                 WHEN g_dblist[li_k].azp03 = "ds"
                    IF l_kind =  "1" OR l_kind = "2" THEN   # 表示ds資料庫有做alter
                       CONTINUE FOR
                    END IF
                 WHEN g_dblist[li_k].azp03 = "wds"
                   IF l_kind =  "1" OR l_kind = "3" THEN   # 表示wds資料庫有做alter
                       CONTINUE FOR
                    END IF
                 OTHERWISE
                    LET g_dblist[li_k].alter_chk = "N"
              END CASE
           END FOR
           
        
         ON ACTION backup_select_all   
            FOR li_k = 1 TO g_dblist.getLength()
           #FOR li_k = 1 TO l_total_cnt   #TQC-BB0134 mark
               LET g_dblist[li_k].backup_chk = "Y"   
            END FOR

         ON ACTION backup_cancel_all   
            FOR li_k = 1 TO g_dblist.getLength()
           #FOR li_k = 1 TO l_total_cnt   #TQC-BB0134 mark
               # ds與wds資料庫若有alter一定要選 
               CASE
                  WHEN g_dblist[li_k].azp03 = "ds"
                     IF l_kind =  "1" OR l_kind = "2" THEN   # 表示ds資料庫有做alter
                        CONTINUE FOR
                     END IF
                  WHEN g_dblist[li_k].azp03 = "wds"
                    IF l_kind =  "1" OR l_kind = "3" THEN   # 表示wds資料庫有做alter
                        CONTINUE FOR
                     END IF
                 OTHERWISE
                     LET g_dblist[li_k].backup_chk = "N"
               END CASE
            END FOR 
          # TQC-BB0216 --- add END ---

        # TQC-BB0216 Mark start
        #ON ACTION select_all
        ##  FOR li_k = 1 TO g_dblist.getLength()
        #   FOR li_k = 1 TO l_total_cnt
        #      LET g_dblist[li_k].chk = "Y"
        #   END FOR
  
        #ON ACTION cancel_all
        ## FOR li_k = 1 TO g_dblist.getLength()
        #  FOR li_k = 1 TO l_total_cnt
        #     # No:FUN-C20069 ---start---
        #     # ds與wds資料庫若有alter一定要選 
        #     CASE
        #        WHEN g_dblist[li_k].azp03 = "ds"
        #           IF l_kind =  "1" OR l_kind = "2" THEN   # 表示ds資料庫有做alter
        #              CONTINUE FOR
        #           END IF
        #        WHEN g_dblist[li_k].azp03 = "wds"
        #           IF l_kind =  "1" OR l_kind = "3" THEN   # 表示wds資料庫有做alter
        #              CONTINUE FOR
        #           END IF
        #        OTHERWISE
        #           LET g_dblist[li_k].chk = "N"
        #     END CASE
        #     # No:FUN-C20069 --- end ---
        #  END FOR
        ## No:FUN-A80074 --- end ---
        # TQC-BB0216 Mark end

         AFTER INPUT
            # 為避免勾選完後直接按執行鍵，系統沒偵測到，須讓勾選結果先寫入Buffer
            IF g_dblist.getLength() > 0 THEN
              #CALL GET_FLDBUF(s_azp03.chk) RETURNING g_dblist[ARR_CURR()].chk                  #TQC-BB0216 mark
               CALL GET_FLDBUF(s_azp03.alter_chk) RETURNING g_dblist[ARR_CURR()].alter_chk      #TQC-BB0216
               CALL GET_FLDBUF(s_azp03.backup_chk) RETURNING g_dblist[ARR_CURR()].backup_chk    #TQC-BB0216               
            END IF
         
         ON ACTION cancel
            CLEAR FROM
            CLOSE WINDOW db_w
            CALL g_dblist.clear()
           #RETURN li_result_final   #TQC-BB0216 mark
            RETURN 2                 #TQC-BB0216 add
      END INPUT
      CLOSE WINDOW db_w
      
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         MESSAGE "取消繼續執行"
         FOR li_i = 1 TO g_dblist.getLength()
      #  FOR li_i = 1 TO l_total_cnt   # 2012/02/24 test
            #LET g_dblist[li_i].chk = "N"           # TQC-BB0216  MARK
             LET g_dblist[li_i].alter_chk = "N"      # TQC-BB0216 add
             LET g_dblist[li_i].backup_chk = "N"     # TQC-BB0216 add
         END FOR
        #LET li_result_final = FALSE   # No:FUN-C20069
        #RETURN li_result_final   #TQC-BB0216 mark
         RETURN 2                 #TQC-BB0216 add   
      END IF
      # TQC-BB0216 --- add end ---
      # No:FUN-C20069 ---start---
      # ds未alter的話，不管wds有沒有alter，ods都不需alter
      IF l_kind = "1" OR l_kind = "2" THEN
     #TQC-D30073 -- mark start --
     #   # No:FUN-A50044 ---start---
     #   # ods資料庫不列在清單上讓使用者選擇，但alter指令仍需進行，
     #   # 所以在最後加上ods的選項，讓程式段也能針對ods資料庫進行alter動作
     #   LET li_i = g_dblist.getLength() + 1
     ##  LET li_i = l_total_cnt + 1    # 2012/02/24 test
     #  #LET g_dblist[li_i].chk = "Y"                      # TQC-BB0216 -- mark
     #   LET g_dblist[li_i].alter_chk = "Y"                # TQC-BB0216 -- add 
     #   LET g_dblist[li_i].backup_chk = "N"               # TQC-BB0216 -- add
     #   LET g_dblist[li_i].azp03 = "ods"
     #   LET g_dblist[li_i].type = "5"       # 表ods資料庫
     ##  LET l_total_cnt = l_total_cnt + 1   # 2012/02/24 test
     #   # No:FUN-A50044 --- end ---
     #TQC-D30073 -- mark end --
      END IF
      # No:FUN-C20069 --- end ---
  
    
      # 先確認存放備份檔的目錄是否存在，若不存在要先建立
      # TQC-BB0216 -- add start --
      CALL os.Path.exists(ls_dbbackup_dir) RETURNING ls_cnt
      IF NOT ls_cnt THEN
         IF os.Path.separator() THEN
            LET l_cmd = "mkdir -p ",ls_dbbackup_dir CLIPPED
         ELSE
            LET l_cmd = "mkdir ",ls_dbbackup_dir CLIPPED
         END IF
         RUN l_cmd RETURNING ls_cnt
         IF ls_cnt THEN
            LET l_cmd = ls_dbbackup_dir CLIPPED,"目錄建立不成功，請再確認"
            CALL cl_err(l_cmd,"!",1)
            LET li_result_final = FALSE
         END IF
      END IF
      # TQC-BB0216 -- add end --
      CALL os.Path.exists(ls_db_dir) RETURNING ls_cnt   # No:FUN-A90064
      IF NOT ls_cnt THEN   # 表示沒找到
         IF os.Path.separator() THEN
            LET l_cmd = "mkdir -p ",ls_db_dir CLIPPED
         ELSE
            LET l_cmd = "mkdir ",ls_db_dir CLIPPED
         END IF
         RUN l_cmd RETURNING ls_cnt
         IF ls_cnt THEN
            LET l_cmd = ls_db_dir CLIPPED,"目錄建立不成功，請再確認"
            CALL cl_err(l_cmd,"!",1)
            LET li_result_final = FALSE
         END IF
      END IF
    
      LET l_str = NULL
      FOR g_cnt = 1 TO g_dblist.getLength()
   #  FOR g_cnt = 1 TO l_total_cnt   # 2012/02/24 test
        #IF g_dblist[g_cnt].chk = "Y" THEN                             # TQC-BB0216 -- mark
         IF g_dblist[g_cnt].backup_chk = "Y" THEN                      # TQC-BB0216 -- add
            #LET ls_i = ls_i + 1                                       # TQC-BB0216 -- mark
            # 先確認是否已做過alter table動作，檢查備份檔是否存在      # TQC-BB0216 -- mark
            # 先確認是否已做過備份的動作，檢查備份檔是否存在           # TQC-BB0216 -- add
            IF g_db_type = "ORA" THEN
               CALL os.Path.exists(os.Path.join(ls_db_dir,g_dblist[g_cnt].azp03 CLIPPED||".dmp")) RETURNING ls_cnt
            ELSE
               CALL os.Path.exists(os.Path.join(ls_db_dir,g_dblist[g_cnt].azp03 CLIPPED||".exp")) RETURNING ls_cnt
            END IF
            IF ls_cnt THEN  # 表示有找到
              #LET l_str = l_str CLIPPED," ",g_dblist[g_cnt].azp03 CLIPPED," 資料庫已做過 alter table 動作，不需再執行一次\n"
              #LET g_dblist[g_cnt].chk = "N"
              #DISPLAY BY NAME g_dblist[g_cnt].*
              #LET ls_i = ls_i - 1
              # TQC-BB0216 -- add start--
               LET l_cmd = "mv ",os.Path.join(ls_db_dir,g_dblist[g_cnt].azp03 CLIPPED||".dmp")," ",os.Path.join(ls_db_dir,g_dblist[g_cnt].azp03 CLIPPED||"_bak.dmp")
               RUN l_cmd
              # TQC-BB0216 -- add end --
            END IF
         END IF
      END FOR
      IF NOT cl_null(l_str) THEN
         CALL p_unpack2_show_msg(l_str)
      END IF
  #END IF                                                             # TQC-BB0216 -- mark
 
  #IF ls_i > 0 THEN    # 若alter table清單中有勾選者才需做此段動作    # TQC-BB0216 -- mark
     #IF cl_prompt(0,0,"是否確定要 alter 所勾選的 database？") THEN   # TQC-BB0216 -- mark
         LET g_show_err = FALSE
         LET g_cnt2 = 1
 
         #先備份所勾選要alter的database
         FOR g_cnt = 1 TO g_dblist.getLength()
        #FOR g_cnt = 1 TO l_total_cnt   # 2012/02/24 test
           #IF g_dblist[g_cnt].chk = "Y" THEN                     # TQC-BB0216 -- mark
            IF g_dblist[g_cnt].backup_chk = "Y" THEN              # TQC-BB0216 -- add
               LET ls_db_file = os.Path.join(ls_db_dir,g_dblist[g_cnt].azp03 CLIPPED||".dmp")
               IF NOT os.Path.exists(ls_db_file) THEN
                  IF os.Path.separator() = "/" THEN
                    #LET l_cmd = "exp ",g_dblist[g_cnt].azp03 CLIPPED,os.Path.separator(),g_dblist[g_cnt].azp03 CLIPPED,
                    #            "@",g_area CLIPPED," file=",ls_db_file                                                         #TQC-C70132
                     LET l_cmd = "exp system",os.Path.separator(),g_pwd CLIPPED,
                                 "@",g_area CLIPPED," owner=",g_dblist[g_cnt].azp03 CLIPPED," file=",ls_db_file CLIPPED         #TQC-C70132
                     RUN l_cmd
                  END IF
               END IF
               IF NOT os.Path.exists(ls_db_file) THEN
                  # 組要顯示於array的訊息
                  LET li_result_final = FALSE
                  LET g_show_err = TRUE
                  LET g_show_alt_msg[g_cnt2].azp03 = g_dblist[g_cnt].azp03 CLIPPED
                  LET g_show_alt_msg[g_cnt2].errcode = ""
                  LET g_show_alt_msg[g_cnt2].ze03 = "資料庫",g_dblist[g_cnt].azp03,"未備份成功，請檢查",ls_db_dir,"後再繼續"
                  LET g_show_alt_msg[g_cnt2].command = l_cmd
                  LET g_cnt2 = g_cnt2 + 1
               END IF
            END IF
         END FOR
 
         IF g_show_err THEN
            IF os.Path.chdir(l_tempdir)THEN                            #TQC-BB0134 add
               CALL p_unpack2_show_err()
            ELSE                                                       #TQC-BB0134 add
               LET l_cmd = "change directory ",l_tempdir," error"      #TQC-BB0134 add
               CALL cl_err(l_cmd,"!",1)                                #TQC-BB0134 add
            END IF                                                     #TQC-BB0134 add
            RETURN li_result_final
         END IF
 
         LET li_result = TRUE
         CALL p_unpack2_alter_table() RETURNING li_result
         IF li_result THEN   #表有失敗
            LET li_result_final = FALSE
         END IF
      #END IF	          # TQC-BB0216 -- mark
   #END IF		  # TQC-BB0216 -- mark
 
   RETURN li_result_final
 
END FUNCTION
 
FUNCTION p_unpack2_show_msg(ps_msg)
   DEFINE  ps_msg     STRING
 
 
   MENU "Message" ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
   END MENU
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
END FUNCTION
 
FUNCTION p_unpack2_alter_table()
   DEFINE   lc_alt_sql_path      STRING
   DEFINE   lc_createtb          base.Channel
   DEFINE   lc_alterr            base.Channel
   DEFINE   li_cnt               LIKE type_file.num5
   DEFINE   ls_alt_result        STRING
   DEFINE   ls_cmd               STRING
   DEFINE   l_sql                STRING
   DEFINE   li_start             LIKE type_file.num5		  # TQC-BB0216 -- add 
   DEFINE   li_createstart       LIKE type_file.num5		  
   DEFINE   ls_memostart         STRING
   DEFINE   ls_memoend           STRING
   DEFINE   li_result            LIKE type_file.num5
   DEFINE   lc_chr10             LIKE type_file.chr10  #固定格式用
   DEFINE   lc_chr14             LIKE type_file.chr14
   DEFINE   lc_memo              LIKE type_file.num5
   DEFINE   ls_db_alt_err        STRING
   DEFINE   ls_db_alt_err_file   STRING
   DEFINE   lc_errmsg            LIKE ze_file.ze03
   DEFINE   lc_errcode1          LIKE ze_file.ze01
   DEFINE   lc_errcode2          LIKE ze_file.ze01
   DEFINE   lc_azw05             LIKE azw_file.azw05   # FUN-A50044
   DEFINE   lc_azw09             LIKE azw_file.azw09   # FUN-A50044
   DEFINE   lc_channel           base.Channel          # FUN-A50044
   DEFINE   lc_end_channel       base.Channel          # FUN-A50044
   DEFINE   lc_alter_sql         STRING                # FUN-A50044
   DEFINE   lc_sql               STRING                # FUN-A50044
   DEFINE   lc_source_file       STRING                # FUN-A50044
   DEFINE   lc_end_file          STRING                # FUN-A50044
   DEFINE   lc_idx               LIKE type_file.num5   # FUN-A50044
  #DEFINE   lc_table             STRING                # FUN-A50044
   DEFINE   lc_table             LIKE type_file.chr20  # TQC-BB0216 
   DEFINE   lc_type              LIKE type_file.chr10  # TQC-BB0216 
   DEFINE   lc_k                 LIKE type_file.num5   # FUN-A50044
   DEFINE   lc_row_cnt           LIKE type_file.num5   # FUN-A50044
   DEFINE   lc_azwd01            LIKE azwd_file.azwd01 # FUN-A50044
   DEFINE   lc_azw06             DYNAMIC ARRAY OF LIKE azw_file.azw06   # FUN-B60010
   DEFINE   lc_i                 LIKE type_file.num5   # FUN-B60121
   DEFINE   lc_str               STRING                # FUN-B60121
   DEFINE   l_tempdir		 STRING                # TQC-BB0134 
   DEFINE   l_cmd		 STRING                # TQC-BB0134
   DEFINE   lc_field             LIKE type_file.chr10  # TQC-BB0216  
   DEFINE   ls_index_name        LIKE type_file.chr10  # TQC-BB0216 
   DEFINE   ls_update_cmd        STRING                # TQC-BB0216 
   DEFINE   lc_table_pk          LIKE type_file.chr20  # TQC-BB0216 
   DEFINE   ls_dropindex_cmd     LIKE type_file.chr50  # TQC-BB0216 
   DEFINE   lc_default           LIKE type_file.chr10  # TQC-BB0216 
   DEFINE   lc_cnt               LIKE type_file.num10  # TQC-BB0216 
   DEFINE   l_noerr_cnt          LIKE type_file.num5   # TQC-BB0216 
   DEFINE   l_ze03               STRING                # TQC-BB0216
   DEFINE   l_bufstr             base.StringBuffer     # TQC-BB0216
   DEFINE   ls_cnt               LIKE type_file.chr1   # TQC-C30059

   LET l_bufstr = base.StringBuffer.create()      # No:TQC-BB0216
   LET l_tempdir=FGL_GETENV('TEMPDIR')	               # TQC-BB0134 add
   LET ls_db_alt_err = os.Path.join(os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup"),g_tarname)
   LET lc_alt_sql_path = os.Path.join(os.Path.join(g_topdir,"pack"),g_tarname)
 
   IF g_db_type = "ORA" THEN
      LET ls_memostart = "/*"
      LET ls_memoend = "*/"
   ELSE
      LET ls_memostart = "{"
      LET ls_memoend = "}"
   END IF
 
   LET g_cnt2 = 1
   LET g_show_err = FALSE
 
   FOR li_cnt = 1 TO g_dblist.getLength()
     #IF g_dblist[li_cnt].chk = "Y" THEN           # TQC-BB0216 -- mark
      IF g_dblist[li_cnt].alter_chk = "Y" THEN	   # TQC-BB0216 -- add
 
         # 轉換資料庫
         LET g_dbs = g_dblist[li_cnt].azp03 CLIPPED
         CALL p_unpack2_set_erpdb()
         IF SQLCA.sqlcode THEN
            RETURN FALSE
         END IF
 
         #錯誤訊息log檔
         LET ls_db_alt_err_file = os.Path.join(ls_db_alt_err,"alter_"||g_dblist[li_cnt].azp03||"_err.log")
         LET lc_alterr = base.Channel.create()
         CALL lc_alterr.openFile(ls_db_alt_err_file,"w")
         CALL lc_alterr.setDelimiter("")
 

         # modify by No:FUN-A50044 ---start---
        #IF g_dblist[li_cnt].azp03 = "ds" THEN
        #   CALL lc_createtb.openFile(lc_alt_sql_path||"alter_ds.sql","r")
        #ELSE
        #   CALL lc_createtb.openFile(lc_alt_sql_path||"alter_others.sql","r")
        #END IF

         CASE
            WHEN g_dblist[li_cnt].type = "1"   # 表ds資料庫
                 LET lc_end_file = os.Path.join(lc_alt_sql_path,"alter_ds.sql")

            WHEN g_dblist[li_cnt].type = "2"   # 表法人DB
                 LET lc_end_file = os.Path.join(lc_alt_sql_path,"alter_legal.sql")

            WHEN g_dblist[li_cnt].type = "3"   # 表法人DB下的所屬DB
                 LET lc_source_file = os.Path.join(lc_alt_sql_path,"alter_under_legal.sql")
                 LET lc_end_file = os.Path.join(lc_alt_sql_path,"alter_"||g_dblist[li_cnt].azp03||".sql")

                 LET lc_channel = base.Channel.create()
                 CALL lc_channel.openFile(lc_source_file, "r")

                 LET lc_end_channel = base.Channel.create()
                 CALL lc_end_channel.setDelimiter("")
                 CALL lc_end_channel.openFile(lc_end_file,"w")
                 LET ls_cmd = "cat  /dev/null > ",lc_end_file
                 RUN ls_cmd

                 # 找出法人DB
                 SELECT DISTINCT azw09 INTO lc_azw09 FROM azw_file
                  WHERE azw05 = azw06 AND azw05 <> azw09
                    AND azw05 = g_dblist[li_cnt].azp03

                 WHILE TRUE
                    LET lc_alter_sql = lc_channel.readLine()
                    IF lc_channel.isEof() THEN
                       EXIT WHILE
                    END IF

                    # 將ds1的字元替代為法人DB
                    CALL cl_replace_str(lc_alter_sql,'ds1',lc_azw09) RETURNING lc_sql

                    CALL lc_end_channel.write(lc_sql)
                 END WHILE
                 CALL lc_channel.close()
                 CALL lc_end_channel.close()

            WHEN g_dblist[li_cnt].type = "4"   # 表虛擬DB
                 LET lc_source_file = os.Path.join(lc_alt_sql_path,"alter_virtual.sql")
                 LET lc_end_file = os.Path.join(lc_alt_sql_path CLIPPED,"alter_"||g_dblist[li_cnt].azp03||".sql")

                 LET lc_channel = base.Channel.create()
                 CALL lc_channel.openFile(lc_source_file, "r")

                 LET lc_end_channel = base.Channel.create()
                 CALL lc_end_channel.setDelimiter("")
                 CALL lc_end_channel.openFile(lc_end_file,"w")
                 LET ls_cmd = "cat  /dev/null > ",lc_end_file
                 RUN ls_cmd

                 # 找出虛擬DB的實體DB
                 SELECT DISTINCT azw05 INTO lc_azw05 FROM azw_file
                  WHERE azw05 <> azw06
                    AND azw06 = g_dblist[li_cnt].azp03

                 WHILE TRUE
                    LET lc_alter_sql = lc_channel.readLine()
                    IF lc_channel.isEof() THEN
                       EXIT WHILE
                    END IF

                    # 將dsall的字元替代為虛擬DB的實體DB
                    CALL cl_replace_str(lc_alter_sql,'dsall',lc_azw05) RETURNING lc_sql

                    CALL lc_end_channel.write(lc_sql)
                 END WHILE
                 CALL lc_channel.close()
                 CALL lc_end_channel.close()

           #TQC-D30073 -- mark start --
           #WHEN g_dblist[li_cnt].type = "5"   # 表ods資料庫
           #     LET lc_source_file = os.Path.join(lc_alt_sql_path,"alter_ods.sql")
           #     LET lc_end_file = os.Path.join(lc_alt_sql_path,"alter_report_db_"||g_dblist[li_cnt].azp03||".sql")

           #     LET lc_channel = base.Channel.create()
           #     CALL lc_channel.openFile(lc_source_file, "r")

           #     LET lc_end_channel = base.Channel.create()
           #     CALL lc_end_channel.setDelimiter("")
           #     CALL lc_end_channel.openFile(lc_end_file,"w")
           #     LET ls_cmd = "cat  /dev/null > ",lc_end_file
           #     RUN ls_cmd

           #     WHILE TRUE
           #        LET lc_alter_sql = lc_channel.readLine()

           #        IF lc_channel.isEof() THEN
           #           EXIT WHILE
           #        END IF

           #        LET lc_idx = lc_alter_sql.getIndexOf('create view',1)
           #        IF lc_idx <> 0 THEN
           #           LET lc_table = lc_alter_sql.subString(lc_alter_sql.getIndexOf("create view ",1)+12,lc_alter_sql.getIndexOf("_file",1)+5)
           #           SELECT COUNT(*) INTO lc_k FROM azwd_file
           #           LET lc_row_cnt = 1
           #           IF lc_k > 0 THEN
           #              # 取得需要列入ods的sql中的db清單
           #              DECLARE p_unpack2_ods_pre CURSOR FOR
           #                 SELECT DISTINCT azwd01 FROM azwd_file
           #                  ORDER BY azwd01
           #              FOREACH p_unpack2_ods_pre INTO lc_azwd01
           #                 # 針對ods組出重建該table的sql語法
           #                 IF lc_row_cnt = 1 THEN
           #                    LET lc_sql = "create view ",lc_table CLIPPED," as ( "
           #                 END IF

           #                 LET lc_sql = lc_sql CLIPPED,"  select '",lc_azwd01 CLIPPED,"' DBNAME, ",
           #                              lc_azwd01 CLIPPED,".",lc_table CLIPPED,".* from ",
           #                              lc_azwd01 CLIPPED,".",lc_table CLIPPED

           #                 IF lc_row_cnt = lc_k THEN
           #                    LET lc_sql = lc_sql CLIPPED," );"
           #                 ELSE
           #                    LET lc_sql = lc_sql CLIPPED," union all "
           #                 END IF
           #                 LET lc_row_cnt = lc_row_cnt + 1
           #              END FOREACH
           #              CALL lc_end_channel.write(lc_sql)
           #           END IF
           #        ELSE
           #           CALL lc_end_channel.write(lc_alter_sql)
           #        END IF
           #     END WHILE
           #     CALL lc_channel.close()
           #     CALL lc_end_channel.close()
           #TQC-D30073 -- mark end --

            # No:FUN-C20069 ---start---
            WHEN g_dblist[li_cnt].type = "6"   # 表wds資料庫
                 LET lc_end_file = os.Path.join(lc_alt_sql_path,"alter_wds.sql")
            # No:FUN-C20069 --- end ---
         END CASE
         # modify by No:FUN-A50044 --- end ---
 
         # 將alter的sql一行一行讀出來執行
         LET lc_createtb = base.Channel.create()
         CALL lc_createtb.openFile(lc_end_file,"r")

         LET li_result = TRUE
         LET lc_memo = FALSE
         LET li_createstart = FALSE
         LET ls_cmd = NULL
         WHILE lc_createtb.read(ls_alt_result)
            # 檔案中可能會有空白行
            IF cl_null(ls_alt_result) THEN
               CONTINUE WHILE
            END IF
 
            LET li_start = FALSE                # TQC-BB0216 -- add
            # 若是create table的話，.sql檔裡面開頭會有該檔案的說明，應忽略
            # 判斷是否有檔頭說明
            IF ls_alt_result = ls_memostart THEN
               LET lc_memo = TRUE
            END IF
 
            # 判斷是否新增table
            IF ls_alt_result.getIndexOf('create table',1) THEN
               LET li_createstart = TRUE
               LET ls_cmd = NULL
            END IF 
 
            #TQC-BB0216 -- add Start --
            # 判斷是否為drop constraint、drop index、ods                                                                                                                                       
            IF (ls_alt_result.getIndexOf('alter table',1) > 0 AND ls_alt_result.getIndexOf('drop constraint',1) > 0) OR                                                                           
               ls_alt_result.getIndexOf('drop index',1) > 0 OR  
               g_dblist[li_cnt].type = "5" THEN     
               LET li_start = TRUE            
               LET ls_cmd = NULL              
            END IF 
            #TQC-BB0216 -- add END --

            IF lc_memo THEN
               IF ls_alt_result = ls_memoend THEN
                  LET lc_memo = FALSE
               END IF
               CONTINUE WHILE
            ELSE
               IF li_createstart THEN
                  # 0.判斷是否新增table      #TQC-BB0216 -- add
                  IF ls_alt_result.getIndexOf(');',1) THEN
                     # 若由程式段執行SQL指令，需將分號拿掉
                     LET ls_alt_result = ls_alt_result.subString(1,ls_alt_result.getLength()-1)
                     LET ls_cmd = ls_cmd CLIPPED,ls_alt_result CLIPPED
                     LET li_createstart = FALSE
 
                     # 去除指令中多餘空白
                     CALL p_unpack2_cut_spaces(ls_cmd) RETURNING ls_cmd
                     EXECUTE IMMEDIATE ls_cmd
                     IF SQLCA.SQLCODE THEN
                        LET lc_errcode1 = SQLCA.SQLCODE
                        LET lc_errcode2 = SQLCA.SQLERRD[2]
                        IF lc_errcode2 <> "-955" THEN      #TQC-BB0216 -- add      
                           IF li_result THEN
                              CALL lc_alterr.write("以下為 alter table 不成功的錯誤碼與指令：")
                              CALL lc_alterr.write("(記錄於"||ls_db_alt_err_file||")")
                              CALL lc_alterr.write("")
                              CALL lc_alterr.write("資料庫別  錯誤碼          指令內容")
                              LET li_result = FALSE
                           END IF
                           LET lc_chr10 = li_cnt USING "##########"
                           IF g_db_type = "ORA" THEN
                              LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                              END IF
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode2 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,"(",lc_errmsg CLIPPED,")"
                              END IF
                           ELSE
                              LET lc_chr14 = SQLCA.sqlcode USING "-----"
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                              END IF
                           END IF
 
                           CALL lc_alterr.write(g_dblist[li_cnt].azp03 CLIPPED||"  "||lc_chr14||"  "||ls_cmd)
 
                           # 組要顯示於array的訊息
                           LET g_show_err = TRUE
                           LET g_show_alt_msg[g_cnt2].azp03 = g_dblist[li_cnt].azp03 CLIPPED
                           LET g_show_alt_msg[g_cnt2].no = g_cnt2                            #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].tarname = g_tarname CLIPPED            #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].command = ls_cmd CLIPPED               #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].errcode = lc_chr14 CLIPPED
                           LET g_cnt2 = g_cnt2 + 1
                        END IF      #TQC-BB0216 -- add
                     END IF
                  ELSE
                     LET ls_cmd = ls_cmd CLIPPED,ls_alt_result CLIPPED
                  END IF

                  # No:FUN-B60010 ---start---
                  # 若該法人DB下有虛擬資料庫，必須在create table完後grant權限給其下所屬的虛擬資料庫
                  IF NOT li_createstart AND g_dblist[li_cnt].type = "2" THEN   # type = 2 表法人DB
                     SELECT COUNT(unique azw06) INTO lc_k FROM azw_file
                      WHERE azw05 <> azw06 AND azw05 = g_dblist[li_cnt].azp03
                     IF lc_k > 0 THEN
                        # 取得新增的table名稱
                        LET lc_table = ls_cmd.subString(ls_cmd.getIndexOf("create table ",1)+12,ls_cmd.getIndexOf("_file",1)+4)

                        # 取得該法人DB下的虛擬資料庫清單
                        DECLARE p_unpack2_legal_pre CURSOR FOR
                         SELECT unique azw06 FROM azw_file
                          WHERE azw05 <> azw06 AND azw05 = g_dblist[li_cnt].azp03
                        LET lc_i = 1
                        FOREACH p_unpack2_legal_pre INTO lc_azw06[lc_i]
                           # 組grant權限的sql語法
                           IF lc_i = 1 THEN
                              LET ls_cmd = "grant select,insert,update,delete on ",lc_table CLIPPED," to ",lc_azw06[lc_i] CLIPPED
                           ELSE
                              LET ls_cmd = ls_cmd,",",lc_azw06[lc_i] CLIPPED
                           END IF

                           LET lc_i = lc_i + 1
                        END FOREACH

                        IF lc_i > 1 THEN
                           EXECUTE IMMEDIATE ls_cmd
                           IF SQLCA.SQLCODE THEN
                              LET lc_errcode1 = SQLCA.SQLCODE
                              LET lc_errcode2 = SQLCA.SQLERRD[2]
                        
                              IF lc_errcode2 <> '-955' THEN    #TQC-BB0216 add
                                 IF li_result THEN
                                    CALL lc_alterr.write("以下為 alter table 不成功的錯誤碼與指令：")
                                    CALL lc_alterr.write("(記錄於"||ls_db_alt_err_file||")")
                                    CALL lc_alterr.write("")
                                    CALL lc_alterr.write("資料庫別  錯誤碼          指令內容")
                                    LET li_result = FALSE
                                 END IF
                                 LET lc_chr10 = li_cnt USING "##########"
                                 IF g_db_type = "ORA" THEN
                                    LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                           
                                    SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                                    IF NOT cl_null(lc_errmsg) THEN
                                       LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                                    END IF
                           
                                    SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode2 AND ze02 = g_lang
                                    IF NOT cl_null(lc_errmsg) THEN
                                       LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,"(",lc_errmsg CLIPPED,")"
                                    END IF
                                 ELSE
                                    LET lc_chr14 = SQLCA.sqlcode USING "-----"
                           
                                    SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                                    IF NOT cl_null(lc_errmsg) THEN
                                       LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                                    END IF
                                 END IF
                           
                                 CALL lc_alterr.write(g_dblist[li_cnt].azp03 CLIPPED||"  "||lc_chr14||"  "||ls_cmd)
                           
                                 # 組要顯示於array的訊息
                                 LET g_show_err = TRUE
                                 LET g_show_alt_msg[g_cnt2].azp03 = g_dblist[li_cnt].azp03 CLIPPED
                                 LET g_show_alt_msg[g_cnt2].no = g_cnt2                          #TQC-BB0216 -- add
                                 LET g_show_alt_msg[g_cnt2].tarname = g_tarname CLIPPED          #TQC-BB0216 -- add
                                 LET g_show_alt_msg[g_cnt2].command = ls_cmd CLIPPED             #TQC-BB0216 -- add
                                 LET g_show_alt_msg[g_cnt2].errcode = lc_chr14 CLIPPED
                                 LET g_cnt2 = g_cnt2 + 1
                              END IF   #TQC-B60010 add
                           END IF
                        END IF
                     END IF
                  END IF
                  # No:FUN-B60010 --- end ---
               ELSE
                  #  TQC-BB0216 -- add start
                  IF li_start THEN
                     # 1.判斷是否為'alter table xxx_file drop constraint xxx_pk;;'的字串
                     #   (1)若有drop constraint,則先到資料庫端撈是否存在INDEX,增加DROP INDEX
                     #   (2)有drop constraint、就drop index
                     IF ls_alt_result.getIndexOf('alter table',1) > 0 AND ls_alt_result.getIndexOf('drop constraint',1) > 0  THEN
                        IF ls_alt_result.getIndexOf(';',1) THEN
                           LET ls_alt_result = ls_alt_result.subString(1,ls_alt_result.getLength()-1)
                           LET ls_cmd = ls_cmd CLIPPED,ls_alt_result CLIPPED

                           LET lc_table = ls_cmd.subString(ls_cmd.getIndexOf("alter table ",1)+12,ls_cmd.getIndexOf("_file",1)+4)
                           LET lc_table_pk = ls_cmd.subString(ls_cmd.getIndexOf("drop constraint ",1)+16,ls_cmd.getIndexOf("_pk",1)+2)     
                           LET lc_table = UPSHIFT(lc_table)
                           SELECT INDEX_NAME INTO ls_index_name FROM user_indexes WHERE table_name= lc_table AND INDEX_NAME LIKE '%_PK'
                           LET lc_table = DOWNSHIFT(lc_table)
                           LET ls_index_name = DOWNSHIFT(ls_index_name)
                           IF ls_index_name = lc_table_pk THEN
                              LET ls_dropindex_cmd = "DROP INDEX ",lc_table_pk CLIPPED
                              # 去除指令中多餘空白
                              CALL p_unpack2_cut_spaces(ls_dropindex_cmd) RETURNING ls_dropindex_cmd
                              EXECUTE IMMEDIATE ls_dropindex_cmd
                           END IF
                           
                           # 執行alter table xxx_file drop constraint xxx_pk;
                           # 去除指令中多餘空白
                           CALL p_unpack2_cut_spaces(ls_cmd) RETURNING ls_cmd
                           EXECUTE IMMEDIATE ls_cmd
                          #因為若客戶家，沒有Drop constraint時，失敗紀錄會沒意義
                        END IF
                     END IF
                     # 2.單純執行SQL指令,忽略錯誤訊息(不儲存錯誤訊息)
                     #   判斷是否為'drop index'的字串、g_dblist[li_cnt].type = "5"  (ods)
                     IF ls_alt_result.getIndexOf('drop index',1) > 0 OR  g_dblist[li_cnt].type = "5" THEN
                        IF ls_alt_result.getIndexOf(';',1) THEN
                           LET ls_alt_result = ls_alt_result.subString(1,ls_alt_result.getLength()-1)
                           LET ls_cmd = ls_cmd CLIPPED,ls_alt_result CLIPPED
                           LET li_start = FALSE 
                           # 去除指令中多餘空白
                           CALL p_unpack2_cut_spaces(ls_cmd) RETURNING ls_cmd
                           EXECUTE IMMEDIATE ls_cmd
                        END IF
                     END IF
                     # TQC-BB0216 -- add end
                  ELSE
                     # 3.非以上SQL指令的情形            
                     IF ls_alt_result.getIndexOf(';',ls_alt_result.getLength()) THEN
                        LET ls_cmd = ls_alt_result.subString(1,ls_alt_result.getLength()-1)
                     ELSE
                        LET ls_cmd = ls_alt_result CLIPPED
                     END IF
                     # 去除指令中多餘空白
                     CALL p_unpack2_cut_spaces(ls_cmd) RETURNING ls_cmd
                     EXECUTE IMMEDIATE ls_cmd
                     IF SQLCA.SQLCODE THEN
                        LET lc_errcode1 = SQLCA.SQLCODE
                        LET lc_errcode2 = SQLCA.SQLERRD[2]
                        IF lc_errcode2 <> "-2260" AND lc_errcode2 <> "-1430" AND lc_errcode2 <> "-1451" AND lc_errcode2 <> "-1442"   #TQC-BB0216 -- add
                            AND lc_errcode2 <> "-955" AND lc_errcode2 <> "-942" AND lc_errcode2 <> "-1434" THEN
                           IF li_result THEN
                              CALL lc_alterr.write("以下為alter不成功的txt行數,錯誤碼與指令 : ")
                              CALL lc_alterr.write("(記錄於"||ls_db_alt_err_file||")")
                              CALL lc_alterr.write("")
                              CALL lc_alterr.write("資料庫別  錯誤碼          指令內容")
                              LET li_result = FALSE
                           END IF
                           LET lc_chr10 = li_cnt USING "##########"
                           IF g_db_type = "ORA" THEN
                              LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                              END IF
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode2 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,"(",lc_errmsg CLIPPED,")"
                              END IF
                           ELSE
                              LET lc_chr14 = SQLCA.sqlcode USING "-----"
 
                              SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                              IF NOT cl_null(lc_errmsg) THEN
                                 LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                              END IF
                           END IF
 
                           CALL lc_alterr.write(g_dblist[li_cnt].azp03 CLIPPED||"  "||lc_chr14||"  "||ls_cmd)
 
                           # 組要顯示於array的訊息
                           LET g_show_err = TRUE
                           LET g_show_alt_msg[g_cnt2].azp03 = g_dblist[li_cnt].azp03 CLIPPED
                           LET g_show_alt_msg[g_cnt2].no = g_cnt2                                 #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].tarname = g_tarname CLIPPED                 #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].command = ls_cmd CLIPPED                    #TQC-BB0216 -- add
                           LET g_show_alt_msg[g_cnt2].errcode = lc_chr14 CLIPPED
                           LET g_cnt2 = g_cnt2 + 1
                        END IF						   #TQC-BB0216 -- add
                     END IF                                                #TQC-BB0216 -- add
                  END IF
               END IF
            END IF
         END WHILE
 
         CALL lc_createtb.close()
         CALL lc_alterr.close()
      END IF
   END FOR
 
   IF g_db_type = "ORA" THEN
      CLOSE DATABASE
   ELSE
      DISCONNECT ALL
   END IF
 
   # No:FUN-A10136 ---start---
   LET g_dbs = "ds"
   CALL p_unpack2_set_erpdb()
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF
   # No:FUN-A10136 --- end ---

   IF g_show_err THEN
      #TQC-BB0216 --add start--
      FOR lc_cnt = 1 TO g_show_alt_msg.getLength()
         LET l_ze03= NULL                                   #因應PAT06欄位空間限制 add
         LET l_sql = "INSERT INTO pat_file VALUES("
         #LET l_sql =l_sql,"'",g_show_alt_msg[lc_cnt].azp03,"','",g_show_alt_msg[lc_cnt].no,"','",g_show_alt_msg[lc_cnt].tarname,"',q'(",g_show_alt_msg[lc_cnt].command,")','",g_show_alt_msg[lc_cnt].errcode,"',q'(",g_show_alt_msg[lc_cnt].ze03,")')"
         LET l_sql =l_sql,"'",g_show_alt_msg[lc_cnt].azp03,"','",g_show_alt_msg[lc_cnt].no,"','",g_show_alt_msg[lc_cnt].tarname,"',q'(",g_show_alt_msg[lc_cnt].command,")','",g_show_alt_msg[lc_cnt].errcode,"','",l_ze03,"')"
         EXECUTE IMMEDIATE l_sql
         IF SQLCA.SQLCODE THEN
            LET lc_errcode1 = SQLCA.SQLCODE
            LET lc_errcode2 = SQLCA.SQLERRD[2]
         END IF
      END FOR
      LET l_noerr_cnt = 0
      FOR li_cnt = 1 TO g_dblist.getLength()
         IF g_dblist[li_cnt].alter_chk = "Y" THEN
            IF g_dblist[li_cnt].type = "4" OR g_dblist[li_cnt].type = "5" THEN
               CONTINUE FOR
            END IF
            SELECT  COUNT(*) INTO l_noerr_cnt FROM pat_file WHERE pat01 = g_dblist[li_cnt].azp03 AND pat03 = g_tarname
            
            IF l_noerr_cnt = 0 THEN
               IF g_dblist[li_cnt].azp03 = "wds" THEN
                  LET l_cmd = "r.sw ",g_dblist[li_cnt].azp03 CLIPPED
                  RUN l_cmd
               ELSE
                  IF os.Path.separator() = "/" THEN    # 表示UNIX系統
                     LET l_cmd = "r.s2 ",g_dblist[li_cnt].azp03 CLIPPED
                     RUN l_cmd
                  ELSE
                     LET l_cmd = "rs2 ",g_dblist[li_cnt].azp03 CLIPPED
                     RUN l_cmd
                  END IF 
               END IF
            END IF  
         END IF
      END FOR   
     #TQC-BB0216 --add END--
      IF os.Path.chdir(l_tempdir)THEN                            #TQC-BB0134 add
         CALL p_unpack2_show_err()
         CALL p_unpack2_show_array(base.TypeInfo.create(g_show_alt_msg),'alter table異常列表','資料庫別|No.|PATCH單號|執行指令|錯誤訊息代號|錯誤訊息內容') #TQC-BB0216 add
         CALL os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)) RETURNING ls_cnt   #TQC-C30059 add
         IF ls_cnt THEN  #TQC-C30059 表示有找到  
            LET l_cmd = "mv ",os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_ERR_list.xls")     #TQC-BB0216 add
            RUN l_cmd
         END IF    #TQC-C30059
      ELSE                                                       #TQC-BB0134 add
         LET l_cmd = "change directory ",l_tempdir," error"      #TQC-BB0134 add
         CALL cl_err(l_cmd,"!",1)                                #TQC-BB0134 add
      END IF                                                     #TQC-BB0134 add
   END IF

   RETURN g_show_err
 
END FUNCTION
 
#清除多餘空白(參考 p_zta 寫法)
FUNCTION p_unpack2_cut_spaces(p_str)
   DEFINE p_str         STRING
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_cmd         STRING
   DEFINE l_desc_stop   LIKE type_file.num5
 
   LET l_flag = 'N'
   LET l_desc_stop = -1
   LET p_str = p_str.trim()
 
   FOR l_i = 1 TO p_str.getLength()
      IF (l_i <= (l_desc_stop + 1) AND g_db_type = "ORA") OR
         (l_i <= l_desc_stop  AND g_db_type = "IFX") THEN
         CONTINUE FOR
      ELSE
         CASE g_db_type
            WHEN "ORA"                                      
               IF l_i = p_str.getIndexOf('/*',l_i) THEN
                  LET l_desc_stop = p_str.getIndexOf('*/',l_i)
                  LET l_cmd = l_cmd,p_str.subString(l_i,l_desc_stop + 1)
               ELSE
                  IF p_str.subString(l_i,l_i) <> ' ' THEN
                     IF l_cmd.getLength() = 0 THEN
                        LET l_cmd = p_str.subString(l_i,l_i)
                     ELSE
                        LET l_cmd = l_cmd,p_str.subString(l_i,l_i)
                     END IF
                     LET l_flag = 'N'
                  ELSE
                     IF l_flag = 'N' THEN
                        LET l_flag = 'Y'
                        LET l_cmd = l_cmd,p_str.subString(l_i,l_i)
                     END IF
                  END IF
               END IF
 
            WHEN "MSV"
         END CASE
      END IF
   END FOR
   RETURN l_cmd
END FUNCTION
 
 
#轉換資料庫(參考p_zta寫法)
FUNCTION p_unpack2_set_erpdb()
   DEFINE l_dbs     LIKE type_file.chr50
   DEFINE l_ch      base.Channel
 
################ for informix synonym ##############
    IF g_db_type="IFX" THEN
       DISCONNECT ALL
       DATABASE g_dbs
    END IF
####################################################
 
    CLOSE DATABASE
    DATABASE g_dbs
 
    IF g_db_type="IFX" THEN
       LET l_ch = base.Channel.create()
       CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERALIASES|awk '{ print $2 }'","r")
       WHILE l_ch.read(g_tcp_servername)
             DISPLAY "tcp_servername:",g_tcp_servername
       END WHILE
       LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
       CONNECT TO l_dbs AS "MAIN"
       IF status THEN
          CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERNAME|awk '{ print $2 }'","r")
          WHILE l_ch.read(g_tcp_servername)
                DISPLAY "tcp_servername:",g_tcp_servername
          END WHILE
          LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
          CONNECT TO l_dbs AS "MAIN"
       END IF
    END IF
END FUNCTION
 
 
FUNCTION p_unpack2_show_err()
   DEFINE lc_gaq03       VARCHAR(255)
   DEFINE lc_show_title   STRING
   DEFINE lc_show_field   STRING
 
   IF g_show_err THEN
      CALL cl_get_feldname("azp03",g_lang) RETURNING lc_gaq03
      LET lc_show_field = lc_show_field.trim(),"|",lc_gaq03 CLIPPED
	  LET lc_show_field = lc_show_field.trim(),"|","No."   #TQC-BB0216
      
      LET lc_show_field = lc_show_field.trim(),"|","PATCH單號"   #TQC-BB0216
      

      LET lc_show_field = lc_show_field.trim(),"|","執行指令"   #TQC-BB0216
     
      LET lc_show_field = lc_show_field.trim(),"|","錯誤訊息代號"
 
      CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03
      LET lc_show_field = lc_show_field.trim(),"|",lc_gaq03 CLIPPED
 
     #LET lc_show_field = lc_show_field.trim(),"|","執行指令"   #TQC-BB0216 mark  
     
      LET lc_show_title = "alter table異常列表"
      CALL cl_show_array(base.TypeInfo.create(g_show_alt_msg),lc_show_title,lc_show_field)
   END IF
END FUNCTION
# No.FUN-970083 --- end ---
#FUN-A10049---add---end---

# No:FUN-A80066 ---start---
FUNCTION p_unpack2_delete_patch_backup()
   DEFINE l_cnt            LIKE type_file.num5
   DEFINE l_choice         LIKE type_file.num5
   DEFINE l_ch_backup      base.Channel
   DEFINE l_backup_file    STRING
   DEFINE l_cmd            STRING
   DEFINE l_exist          LIKE type_file.num5
   DEFINE l_i              LIKE type_file.num5
   DEFINE l_file1          STRING
   DEFINE l_file2          STRING


   # 因unpack目錄下會有patch的備份檔，而unpack/db_backup下則是存放資料庫備份檔，
   # 應該都要列在清單上讓解包人員選擇是否要刪除
   LET l_file1 = os.Path.join(FGL_GETENV('TOP'),"unpack")
   LET l_file2 = os.Path.join(os.Path.join(FGL_GETENV('TOP'),"unpack"),"db_backup")

   LET l_choice = FALSE
   LET l_ch_backup = base.Channel.create()

   # No:FUN-A90064 ---start---
   # 先找unpack目錄下的檔案
   LET l_cnt = 1

   CALL os.Path.dirsort("name",1)
   LET l_i = os.Path.diropen(l_file1)
   WHILE l_i > 0
      LET l_backup_file = os.Path.dirnext(l_i)
      IF cl_null(l_backup_file) THEN
         EXIT WHILE
      END IF
      IF l_backup_file = "." OR l_backup_file = ".." THEN
         CONTINUE WHILE
      END IF
      IF l_backup_file = "db_backup" THEN
         CONTINUE WHILE
      END IF
      LET ts[l_cnt].sel = "N"
      LET ts[l_cnt].filename = l_backup_file
      LET l_cnt = l_cnt + 1
   END WHILE
   CALL os.Path.dirclose(l_i)

   # 再找unpack/db_backup下的檔案
   CALL os.Path.exists(l_file2) RETURNING l_exist
   IF l_exist THEN    # 表示有找到
      CALL os.Path.dirsort("name",1)
      LET l_i = os.Path.diropen(l_file2)
      WHILE l_i > 0
         LET l_backup_file = os.Path.dirnext(l_i)
         IF cl_null(l_backup_file) THEN
            EXIT WHILE
         END IF
         IF l_backup_file = "." OR l_backup_file = ".." THEN
            CONTINUE WHILE
         END IF
         LET ts[l_cnt].sel = "N"
         LET ts[l_cnt].filename = l_backup_file
         LET l_cnt = l_cnt + 1
      END WHILE
      CALL os.Path.dirclose(l_i)
   END IF
   # No:FUN-A90064 --- end ---

   OPEN WINDOW backup_list_w WITH FORM "azz/42f/p_unpack2_patch_list.42f"
   CALL cl_ui_locale("p_unpack2_patch_list")

   INPUT ARRAY ts WITHOUT DEFAULTS FROM s_list.*
      ATTRIBUTE(COUNT=ts.getLength(),MAXCOUNT=ts.getLength(),UNBUFFERED,
                INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE)

      ON ACTION sel_all   # 全選
         FOR l_i = 1 TO ts.getLength()
            LET ts[l_i].sel = "Y"
         END FOR

      ON ACTION cancel_all   # 取消全選
         FOR l_i = 1 TO ts.getLength()
            LET ts[l_i].sel = "N"
         END FOR

      AFTER INPUT
         # 為避免勾選完後直接按執行鍵，系統沒偵測到，須讓勾選結果先寫入Buffer
         IF ts.getLength() > 0 THEN
            CALL GET_FLDBUF(s_list.sel) RETURNING ts[ARR_CURR()].sel
         END IF
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      MESSAGE "取消繼續執行"
      FOR l_i = 1 TO ts.getLength()
         LET ts[l_i].sel = "N"
      END FOR
   END IF

   FOR l_i = 1 TO ts.getLength()
      IF ts[l_i].sel = "Y" THEN
         LET l_choice = TRUE
      END IF
   END FOR

   IF l_choice THEN
      IF cl_prompt(0,0,"是否確定要刪除所勾選的patch備份檔？") THEN
         FOR l_i = 1 TO ts.getLength()
            IF ts[l_i].sel = "Y" THEN
               CALL os.Path.exists(os.Path.join(l_file1,ts[l_i].filename)) RETURNING l_exist
               IF NOT l_exist THEN   # 表示沒找到
                  CALL os.Path.exists(os.Path.join(l_file2,ts[l_i].filename)) RETURNING l_exist
                  IF l_exist THEN   # 表示有找到
                     IF NOT os.Path.delete(os.Path.join(l_file2,ts[l_i].filename)) THEN  # 表示刪除失敗
                        DISPLAY "delete file ",os.Path.join(l_file2,ts[l_i].filename)," failed."
                     END IF
                  END IF
               ELSE
                  IF NOT os.Path.delete(os.Path.join(l_file1,ts[l_i].filename)) THEN  # 表示刪除失敗
                     DISPLAY "delete file ",os.Path.join(l_file1,ts[l_i].filename)," failed."
                  END IF
               END IF
            END IF
         END FOR
      END IF
   END IF
   CLOSE WINDOW backup_list_w
END FUNCTION
# No:FUN-A80066 --- end ---
# No:FUN-B60112

#TQC-BB0216 -- add start --
FUNCTION p_unpack2_pat_alter()
      DEFINE   l_ac                 LIKE type_file.num5
      DEFINE   l_db_w_cnt           LIKE type_file.num5
      DEFINE   l_sql                STRING      
      DEFINE   ls_db_alt_err_file   STRING
      DEFINE   ls_db_alt_err        STRING
      DEFINE   l_err                INTEGER
      DEFINE   l_cmd                STRING
      DEFINE   l_cnt                LIKE type_file.num5
      DEFINE   l_ds4gl_path         STRING
      DEFINE   ls_db_dir            STRING
      DEFINE   ls_dbbackup_dir      STRING
      DEFINE   ls_db_file           STRING
      DEFINE   li_result_final      LIKE type_file.num5
      DEFINE   li_result            LIKE type_file.num5
      DEFINE   lc_alterr            base.Channel
      DEFINE   ls_cmd               STRING
      DEFINE   lc_errcode1          LIKE ze_file.ze01
      DEFINE   lc_errcode2          LIKE ze_file.ze01
      DEFINE   lc_chr10             LIKE type_file.chr10  #固定格式用
      DEFINE   li_cnt               LIKE type_file.num5
      DEFINE   lc_chr14             LIKE type_file.chr14
      DEFINE   lc_errmsg            LIKE ze_file.ze03 
      DEFINE   ls_cnt               LIKE type_file.num5
      DEFINE   l_str                STRING
      DEFINE   l_tempdir            STRING  
      DEFINE   l_errdb_str          STRING
      DEFINE   l_noerr_cnt          LIKE type_file.num5
      
      LET l_tempdir = FGL_GETENV('TEMPDIR') 

      CALL g_pat_alt_list.clear()
      LET g_cnt2 = 1
      LET l_ds4gl_path= FGL_GETENV('DS4GL')
      LET li_result_final = TRUE
      
      LET l_ac = 1
      LET l_sql = "SELECT  DISTINCT pat01 FROM pat_file",
                  " WHERE pat03 = '",g_tarname CLIPPED,"' AND pat02 <> 0"
      PREPARE pat_pare2 FROM l_sql
      DECLARE pat_err_db_curs2 CURSOR FOR pat_pare2
      FOREACH pat_err_db_curs2 INTO g_pat_alt_list[l_ac].azp03
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET l_ac =l_ac + 1
      END FOREACH
      CALL g_pat_alt_list.deleteElement(l_ac)
      
      LET delete_chk = "N"
      OPEN WINDOW pat_db_w WITH FORM "azz/42f/p_unpack2_sel_ab.42f" 		    
      CALL cl_ui_locale("p_unpack2_sel_ab")
	  INPUT BY NAME g_pwd,g_pwd_sys,delete_chk WITHOUT DEFAULTS
         
         BEFORE INPUT
            CALL cl_set_comp_entry("g_pwd",TRUE)
            CALL cl_set_comp_entry("g_pwd_sys",TRUE)
            CALL cl_set_comp_entry("delete_chk",TRUE)
            
         AFTER INPUT
           LET l_err = 1   
           LET l_cmd = "sh ",l_ds4gl_path,"/bin/patchtemp.sh ",g_pwd CLIPPED," ",g_pwd_sys CLIPPED," | tee  /tmp/patchtemp.chk"    
           RUN l_cmd                                                                                                              
           LET l_cmd = "grep 'Wrong passwd' /tmp/patchtemp.chk"                                                                            
           RUN l_cmd RETURNING l_err                                                                                              
           IF l_err = 0 THEN
              LET l_err = 1
              CALL cl_err("SYS、SYSTEM",'azz-865',1)
              NEXT FIELD g_pwd
           ELSE
              LET l_err = 0
           END IF
           
         ON CHANGE delete_chk
             IF delete_chk = "Y" THEN
                CALL p_unpack2_delete_patch_backup()
             END IF

         ON ACTION cancel
            CLEAR FROM
            CLOSE WINDOW pat_db_w
            CALL g_pat_alt_list.clear()
           #RETURN li_result_final
            RETURN 2
     END INPUT
     
     INPUT ARRAY g_pat_alt_list WITHOUT DEFAULTS FROM s_azp03.*
         ATTRIBUTE(COUNT=g_pat_alt_list.getLength(),MAXCOUNT=g_pat_alt_list.getLength(),UNBUFFERED,
                   INSERT ROW=FALSE,APPEND ROW=FALSE,DELETE ROW=FALSE) 
         BEFORE INPUT 
            FOR l_cnt = 1 TO g_pat_alt_list.getLength()
              LET  g_pat_alt_list[l_cnt].alter_chk  = "Y"
              LET  g_pat_alt_list[l_cnt].backup_chk = "N"
            END FOR           
        
         AFTER INPUT
            # 為避免勾選完後直接按執行鍵，系統沒偵測到，須讓勾選結果先寫入Buffer
            IF g_pat_alt_list.getLength() > 0 THEN
               CALL GET_FLDBUF(s_azp03.alter_chk) RETURNING g_pat_alt_list[ARR_CURR()].alter_chk 		 
               CALL GET_FLDBUF(s_azp03.backup_chk) RETURNING g_pat_alt_list[ARR_CURR()].backup_chk     
            END IF
            	
	 ON ACTION alter_select_all 
            FOR l_cnt = 1 TO g_pat_alt_list.getLength()
              LET  g_pat_alt_list[l_cnt].alter_chk  = "Y"
            END FOR 

         ON ACTION alter_cancel_all  
           FOR l_cnt = 1 TO g_pat_alt_list.getLength()
              #IF g_pat_alt_list[l_cnt].azp03 = "ds" THEN
              #   CONTINUE FOR
              #ELSE
                 LET g_pat_alt_list[l_cnt].alter_chk = "N" 
              #END IF
           END FOR
           
        
         ON ACTION backup_select_all   
            FOR l_cnt = 1 TO g_pat_alt_list.getLength()
               LET g_pat_alt_list[l_cnt].backup_chk = "Y"   
            END FOR

         ON ACTION backup_cancel_all   
           FOR l_cnt = 1 TO g_pat_alt_list.getLength()
              ## ds資料庫一定要選 
               IF g_pat_alt_list[l_cnt].azp03 = "ds" THEN
                  CONTINUE FOR
               ELSE
                 LET g_pat_alt_list[l_cnt].backup_chk = "N"  
               END IF
           END FOR

         ON ACTION cancel
            CLEAR FROM
            CLOSE WINDOW pat_db_w
            CALL g_pat_alt_list.clear()
           #RETURN li_result_final
            RETURN 2


     END INPUT
     CLOSE WINDOW pat_db_w
    
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         MESSAGE "取消繼續執行"
         FOR li_cnt = 1 TO g_pat_alt_list.getLength()
            LET g_pat_alt_list[li_cnt].alter_chk = "N"      
            LET g_pat_alt_list[li_cnt].backup_chk = "N"    
         END FOR
         LET li_result_final = FALSE
        #RETURN li_result_final
         RETURN 2
      END IF
     
     LET g_cnt = 1
     LET ls_dbbackup_dir = os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup")  
     LET ls_db_dir = os.Path.join(os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup"),g_tarname)

     # 先確認存放備份檔的目錄是否存在，若不存在要先建立
     CALL os.Path.exists(ls_dbbackup_dir) RETURNING ls_cnt
     IF NOT ls_cnt THEN
        IF os.Path.separator() THEN
           LET l_cmd = "mkdir -p ",ls_dbbackup_dir CLIPPED
        ELSE
           LET l_cmd = "mkdir ",ls_dbbackup_dir CLIPPED
        END IF
        RUN l_cmd RETURNING ls_cnt
        IF ls_cnt THEN
           LET l_cmd = ls_dbbackup_dir CLIPPED,"目錄建立不成功，請再確認"
           CALL cl_err(l_cmd,"!",1)
           LET li_result_final = FALSE
        END IF
     END IF
     CALL os.Path.exists(ls_db_dir) RETURNING ls_cnt   
     IF NOT ls_cnt THEN   # 表示沒找到
        IF os.Path.separator() THEN
           LET l_cmd = "mkdir -p ",ls_db_dir CLIPPED
        ELSE
           LET l_cmd = "mkdir ",ls_db_dir CLIPPED
        END IF
        RUN l_cmd RETURNING ls_cnt
        IF ls_cnt THEN
           LET l_cmd = ls_db_dir CLIPPED,"目錄建立不成功，請再確認"
           CALL cl_err(l_cmd,"!",1)
           LET li_result_final = FALSE
        END IF
     END IF
     
     LET l_str = NULL
     FOR g_cnt = 1 TO g_pat_alt_list.getLength()
        IF g_pat_alt_list[g_cnt].backup_chk = "Y" THEN		
            IF g_db_type = "ORA" THEN
               CALL os.Path.exists(os.Path.join(ls_db_dir,g_pat_alt_list[g_cnt].azp03 CLIPPED||".dmp")) RETURNING ls_cnt
            ELSE
               CALL os.Path.exists(os.Path.join(ls_db_dir,g_pat_alt_list[g_cnt].azp03 CLIPPED||".exp")) RETURNING ls_cnt
            END IF
            IF ls_cnt THEN  # 表示有找到
               LET l_cmd = "mv ",os.Path.join(ls_db_dir,g_pat_alt_list[g_cnt].azp03 CLIPPED||".dmp")," ",os.Path.join(ls_db_dir,g_pat_alt_list[g_cnt].azp03 CLIPPED||"_bak.dmp")
               RUN l_cmd
            END IF
         END IF
     END FOR
     IF NOT cl_null(l_str) THEN
        CALL p_unpack2_show_msg(l_str)
     END IF
    
     FOR l_cnt = 1 TO g_pat_alt_list.getLength()
        IF g_pat_alt_list[l_cnt].backup_chk = "Y" THEN
           LET ls_db_file = os.Path.join(ls_db_dir,g_pat_alt_list[g_cnt].azp03 CLIPPED||".dmp")
           IF NOT os.Path.exists(ls_db_file) THEN
              IF os.Path.separator() = "/" THEN
                #LET l_cmd = "exp ",g_pat_alt_list[g_cnt].azp03 CLIPPED,os.Path.separator(),g_pat_alt_list[g_cnt].azp03 CLIPPED,
                #            "@",g_area CLIPPED," file=",ls_db_file                       
                 LET l_cmd = "exp system",os.Path.separator(),g_pwd CLIPPED,
                             "@",g_area CLIPPED," owner=",g_pat_alt_list[g_cnt].azp03 CLIPPED," file=",ls_db_file CLIPPED         #TQC-C70132
                 RUN l_cmd
              END IF
           END IF
           IF NOT os.Path.exists(ls_db_file) THEN
              # 組要顯示於array的訊息
              LET li_result_final = FALSE
              LET g_show_err = TRUE
              LET g_show_alt_msg[g_cnt2].azp03 = g_pat_alt_list[g_cnt].azp03 CLIPPED
              LET g_show_alt_msg[g_cnt2].errcode = ""
              LET g_show_alt_msg[g_cnt2].ze03 = "資料庫",g_pat_alt_list[g_cnt].azp03,"未備份成功，請檢查",ls_db_dir,"後再繼續"
              LET g_show_alt_msg[g_cnt2].command = l_cmd
              LET g_cnt2 = g_cnt2 + 1
           END IF
        END IF
     END FOR
     
     IF g_show_err THEN
        IF os.Path.chdir(l_tempdir)THEN                            #TQC-BB0134 add 
           CALL p_unpack2_show_err()
        ELSE                                                       #TQC-BB0134 add
         LET l_cmd = "change directory ",l_tempdir," error"      #TQC-BB0134 add
         CALL cl_err(l_cmd,"!",1)                                #TQC-BB0134 add
        END IF                                                     #TQC-BB0134 add
        RETURN li_result_final
     END IF
 
     LET li_result = TRUE
     
     LET l_ac = 1
     LET l_sql = "SELECT pat01,pat02,pat04 FROM pat_file ",
                 "WHERE pat03 = '",g_tarname CLIPPED,"'" 
     PREPARE cmd_pare2 FROM l_sql
     DECLARE pat_cmd_curs2 CURSOR FOR cmd_pare2
     FOREACH pat_cmd_curs2 INTO g_alter_err_db[l_ac].*
        IF SQLCA.sqlcode THEN
           EXIT FOREACH
        END IF 
        LET l_ac = l_ac + 1    
     END FOREACH        
     CALL g_alter_err_db.deleteElement(l_ac)

     LET ls_db_alt_err = os.Path.join(os.Path.join(os.Path.join(g_topdir,"unpack"),"db_backup"),g_tarname)

     LET g_show_err = FALSE
     LET li_result = TRUE
     LET l_errdb_str = NULL
     LET g_cnt2 = 1
     
     FOR l_db_w_cnt = 1 TO g_pat_alt_list.getLength()   #掃出開窗所選擇的要ALTER DB
        IF g_pat_alt_list[l_db_w_cnt].alter_chk = "Y" THEN   # Y
           FOR l_cnt = 1 TO g_alter_err_db.getLength()
              IF g_pat_alt_list[l_db_w_cnt].azp03 = g_alter_err_db[l_cnt].db THEN
                 #錯誤訊息log檔
                 LET ls_db_alt_err_file = os.Path.join(ls_db_alt_err,"alter_"||g_alter_err_db[l_cnt].db||"_err.log")
                 LET lc_alterr = base.Channel.create()
                 CALL lc_alterr.openFile(ls_db_alt_err_file,"w")
                 CALL lc_alterr.setDelimiter("")            
                 # 轉換資料庫
                 LET g_dbs = g_alter_err_db[l_cnt].db CLIPPED
                 CALL p_unpack2_set_erpdb()
                 IF SQLCA.sqlcode THEN
                    RETURN FALSE
                 END IF

                 LET ls_cmd = g_alter_err_db[l_cnt].command
                 CALL p_unpack2_cut_spaces(ls_cmd) RETURNING ls_cmd
                 EXECUTE IMMEDIATE ls_cmd
                 IF SQLCA.SQLCODE THEN
                    LET lc_errcode1 = SQLCA.SQLCODE
                    LET lc_errcode2 = SQLCA.SQLERRD[2]
                    IF lc_errcode2 <> "-2260" AND lc_errcode2 <> "-1430" AND lc_errcode2 <> "-1451" AND lc_errcode2 <> "-1442"    #TQC-C30059 add
                           AND lc_errcode2 <> "-955" AND lc_errcode2 <> "-942" AND lc_errcode2 <> "-1434" THEN               
                       IF li_result THEN
                          CALL lc_alterr.write("以下為 alter table 不成功的錯誤碼與指令：")
                          CALL lc_alterr.write("(記錄於"||ls_db_alt_err_file||")")
                          CALL lc_alterr.write("")
                          CALL lc_alterr.write("資料庫別  錯誤碼          指令內容")
                          LET li_result = FALSE
                       END IF
                       LET lc_chr10 = li_cnt USING "##########"
                       IF g_db_type = "ORA" THEN
                          LET lc_chr14 = SQLCA.sqlcode USING "-----","(",SQLCA.sqlerrd[2] USING "-------",")"
                          SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                          IF NOT cl_null(lc_errmsg) THEN
                             LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                          END IF
   
                          SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode2 AND ze02 = g_lang
                          IF NOT cl_null(lc_errmsg) THEN
                             LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,"(",lc_errmsg CLIPPED,")"
                          END IF
                       ELSE
                          LET lc_chr14 = SQLCA.sqlcode USING "-----"
                          SELECT ze03 INTO lc_errmsg FROM ze_file WHERE ze01 = lc_errcode1 AND ze02 = g_lang
                          IF NOT cl_null(lc_errmsg) THEN
                             LET g_show_alt_msg[g_cnt2].ze03 = g_show_alt_msg[g_cnt2].ze03 CLIPPED,lc_errmsg CLIPPED
                          END IF
                       END IF

                       CALL lc_alterr.write(g_alter_err_db[l_cnt].db CLIPPED||"  "||lc_chr14||"  "||ls_cmd)

                       # 組要顯示於array的訊息
                       LET g_show_err = TRUE
                       LET g_show_alt_msg[g_cnt2].azp03 = g_alter_err_db[l_cnt].db CLIPPED
                       LET g_show_alt_msg[g_cnt2].errcode = lc_chr14 CLIPPED
                       LET g_show_alt_msg[g_cnt2].command = ls_cmd
                       LET g_show_alt_msg[g_cnt2].tarname = g_tarname CLIPPED   
                       #LET g_show_alt_msg[g_cnt2].no =g_cnt2                    
                       LET g_cnt2 = g_cnt2 + 1           
                    #TQC-C30059 -- add start --
                    ELSE
                    LET l_cmd = "DELETE FROM pat_file ",
                                   "WHERE pat01 = '",g_alter_err_db[l_cnt].db CLIPPED,"' AND pat02 = '",g_alter_err_db[l_cnt].no CLIPPED,"' AND pat03 = '",g_tarname CLIPPED,"'"
                       CALL p_unpack2_cut_spaces(l_cmd) RETURNING l_cmd
                       LET l_cmd = cl_replace_str(l_cmd,"'","\"")
                       LET g_dbs = "ds"
                       CALL p_unpack2_set_erpdb()
                       EXECUTE IMMEDIATE l_cmd
                       IF SQLCA.SQLERRD[3] = 0 THEN
                          LET lc_errcode1 = SQLCA.SQLCODE
                          LET lc_errcode2 = SQLCA.SQLERRD[2] 
                       END IF
                    END IF
                    #TQC-C30059 -- add end --
                 ELSE
                    IF SQLCA.SQLCODE = 0 THEN
                      LET l_cmd = "DELETE FROM pat_file ",
                                   "WHERE pat01 = '",g_alter_err_db[l_cnt].db CLIPPED,"' AND pat02 = '",g_alter_err_db[l_cnt].no CLIPPED,"' AND pat03 = '",g_tarname CLIPPED,"'"
                       CALL p_unpack2_cut_spaces(l_cmd) RETURNING l_cmd
                       LET l_cmd = cl_replace_str(l_cmd,"'","\"")
                       LET g_dbs = "ds"
                       CALL p_unpack2_set_erpdb()
                       EXECUTE IMMEDIATE l_cmd
                       IF SQLCA.SQLERRD[3] = 0 THEN
                          LET lc_errcode1 = SQLCA.SQLCODE
                          LET lc_errcode2 = SQLCA.SQLERRD[2]
                       END IF
                    END IF
                 END IF
              END IF      
           END FOR
        END IF
     END FOR
     CALL lc_alterr.close()

     LET l_noerr_cnt = 0
     FOR li_cnt = 1 TO g_pat_alt_list.getLength()
        IF  g_pat_alt_list[li_cnt].alter_chk = "Y" THEN
            SELECT COUNT(*) INTO l_noerr_cnt FROM pat_file WHERE pat01 = g_pat_alt_list[li_cnt].azp03            
            IF l_noerr_cnt = 0 THEN
               IF g_dblist[li_cnt].azp03 = "wds" THEN
                  LET l_cmd = "r.sw ",g_dblist[li_cnt].azp03 CLIPPED
                  RUN l_cmd
               ELSE
                  IF os.Path.separator() = "/" THEN    # 表示UNIX系統
                  LET l_cmd = "r.s2 ",g_pat_alt_list[li_cnt].azp03 CLIPPED
                  RUN l_cmd
               ELSE
                  LET l_cmd = "rs2 ",g_pat_alt_list[li_cnt].azp03 CLIPPED
                  RUN l_cmd
               END IF 
               END IF
            END IF  
        END IF
     END FOR 
     
     IF g_show_err THEN
        LET li_result_final = FALSE
        IF os.Path.chdir(l_tempdir)THEN			
           CALL p_unpack2_show_err()
           CALL p_unpack2_show_array(base.TypeInfo.create(g_show_alt_msg),'alter table異常列表','資料庫別|No.|PATCH單號|執行指令|錯誤訊息代號|錯誤訊息內容')                               
           CALL os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)) RETURNING ls_cnt   #TQC-C30059 add
           IF ls_cnt THEN  #TQC-C30059 add 表示有找到  
              LET l_cmd = "mv ",os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_ERR_list.xls")     
              RUN l_cmd
           END IF     #TQC-C30059 add
        ELSE							
           LET l_cmd = "change directory ",l_tempdir," error"	
           CALL cl_err(l_cmd,"!",1)				
        END IF
     ELSE
        CALL g_show_alt_msg.clear()
        LET l_ac = 1
        LET l_sql = "SELECT * FROM pat_file ",
                    "WHERE pat03 = '",g_tarname CLIPPED,"'" 
        PREPARE cmd_pare3 FROM l_sql
        DECLARE pat_cmd_curs3 CURSOR FOR cmd_pare3
        FOREACH pat_cmd_curs3 INTO g_show_alt_msg[l_ac].*
           IF SQLCA.sqlcode THEN
              EXIT FOREACH
           END IF 
           LET l_ac = l_ac + 1    
        END FOREACH        
        CALL g_show_alt_msg.deleteElement(l_ac)
        CALL p_unpack2_show_array(base.TypeInfo.create(g_show_alt_msg),'alter table異常列表','資料庫別|No.|PATCH單號|執行指令|錯誤訊息代號|錯誤訊息內容')                               
        CALL os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)) RETURNING ls_cnt   #TQC-C30059 add
        IF ls_cnt THEN  #TQC-C30059 add 表示有找到  
           LET l_cmd = "mv ",os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)," ",os.Path.join(os.Path.join(os.Path.join(FGL_GETENV("TOP"),"pack"),g_tarname),"alter_ERR_list.xls")     
           RUN l_cmd
        END IF          #TQC-C30059 add
     END IF
     
   RETURN li_result_final
     
END FUNCTION

################################################################################################
################################################################################################

# Descriptions...: 開窗顯示array內容
# Input Parameter: pnode_array  傳入base.TypeInfo.create(array變數)
#                  ps_win_title 作為畫面上方的title字串
#                  ps_title_str 作為table中各欄位Title的字串，轉好多語言後，請用"|"組合傳入
# Return Code....:
 
FUNCTION p_unpack2_show_array(pnode_array,ps_win_title,ps_title_str)
   DEFINE   pnode_array      om.DomNode
   DEFINE   ps_win_title     STRING
   DEFINE   ps_title_str     STRING
   DEFINE   lnode_record     om.DomNode
   DEFINE   llst_fields      om.NodeList
   DEFINE   lnode_field      om.DomNode
   DEFINE   llst_rec_fields  om.NodeList
   DEFINE   li_child_cnt     LIKE type_file.num5       #No.FUN-690005  SMALLINT
   DEFINE   li_rec_cnt       LIKE type_file.num10      #No.FUN-690005  INTEGER
   DEFINE   lr_array         DYNAMIC ARRAY OF RECORD
               field1        STRING,
               field2        STRING,
               field3        STRING,
               field4        STRING,
               field5        STRING,
               field6        STRING,
               field7        STRING,
               field8        STRING,
               field9        STRING,
               field10       STRING,
               field11       STRING
                             END RECORD
   DEFINE   label_name       DYNAMIC ARRAY OF RECORD
            id               STRING
                             END RECORD
   DEFINE   ls_visible_str   STRING
   DEFINE   li_i             LIKE type_file.num10       #No.FUN-690005  SMALLINT
   DEFINE   li_j             LIKE type_file.num10       #No.FUN-690005  SMALLINT
   DEFINE   ls_i             STRING
   DEFINE   lst_title_names  base.StringTokenizer
   DEFINE   ls_title         STRING
   DEFINE   w                ui.Window                 #TQC-890001
   DEFINE   n                om.DomNode                #TQC-890001  
 
 
   IF pnode_array IS NULL THEN
      RETURN
   ELSE
      LET li_rec_cnt = pnode_array.getChildCount()
      LET lnode_record = pnode_array.getFirstChild()
   END IF
 
   IF lnode_record IS NULL THEN
      RETURN
   ELSE
      LET llst_rec_fields = lnode_record.selectByTagName("Field")
      LET li_child_cnt = llst_rec_fields.getLength()
   END IF
 
   FOR li_i = 1 TO li_rec_cnt
       IF li_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )    #No.TQC-630109
          EXIT FOR
       END IF
 
       IF li_i = 1 THEN
          LET lnode_record = pnode_array.getFirstChild()
       ELSE
          LET lnode_record = lnode_record.getNext()
       END IF
 
       LET llst_fields = lnode_record.selectByTagName("Field")
       FOR li_j = 1 TO llst_fields.getLength()
           LET lnode_field = llst_fields.item(li_j)
 
           CASE li_j
              WHEN 1
                 LET lr_array[li_i].field1 = lnode_field.getAttribute("value")
              WHEN 2
                 LET lr_array[li_i].field2 = lnode_field.getAttribute("value")
              WHEN 3
                 LET lr_array[li_i].field3 = lnode_field.getAttribute("value")
              WHEN 4
                 LET lr_array[li_i].field4 = lnode_field.getAttribute("value")
              WHEN 5
                 LET lr_array[li_i].field5 = lnode_field.getAttribute("value")
              WHEN 6
                 LET lr_array[li_i].field6 = lnode_field.getAttribute("value")
              WHEN 7
                 LET lr_array[li_i].field7 = lnode_field.getAttribute("value")
              WHEN 8
                 LET lr_array[li_i].field8 = lnode_field.getAttribute("value")
              WHEN 9
                 LET lr_array[li_i].field9 = lnode_field.getAttribute("value")
              WHEN 10
                 LET lr_array[li_i].field10 = lnode_field.getAttribute("value")
           END CASE
       END FOR
   END FOR
   
         FOR li_i = li_child_cnt + 1 TO 10
             LET ls_i = li_i
             LET ls_visible_str = ls_visible_str,"field",ls_i
             IF li_i != 10 THEN
                LET ls_visible_str = ls_visible_str,","
             END IF
             CASE li_i
              WHEN 2
                 LET lr_array[li_i].field2 = NULL
              WHEN 3
                 LET lr_array[li_i].field3 = NULL
              WHEN 4
                 LET lr_array[li_i].field4 = NULL
              WHEN 5
                 LET lr_array[li_i].field5 = NULL
              WHEN 6
                 LET lr_array[li_i].field6 = NULL
              WHEN 7
                 LET lr_array[li_i].field7 = NULL
              WHEN 8
                 LET lr_array[li_i].field8 = NULL
              WHEN 9
                 LET lr_array[li_i].field9 = NULL
              WHEN 10
                 LET lr_array[li_i].field10 = NULL
              WHEN 11
                 LET lr_array[li_i].field11 = NULL
           END CASE
         END FOR
         CALL cl_set_comp_visible(ls_visible_str,FALSE)
 
         LET lst_title_names = base.StringTokenizer.create(ps_title_str,"|")
         LET li_i = 1
         WHILE lst_title_names.hasMoreTokens()
            LET ls_title = lst_title_names.nextToken()
            LET ls_title = ls_title.trim()
 
            CASE li_i
               WHEN 1
                  LET label_name[li_i].id = ls_title
               WHEN 2
                  LET label_name[li_i].id = ls_title
               WHEN 3
                  LET label_name[li_i].id = ls_title
               WHEN 4
                  LET label_name[li_i].id = ls_title
               WHEN 5
                  LET label_name[li_i].id = ls_title
               WHEN 6
                  LET label_name[li_i].id = ls_title
               WHEN 7
                  LET label_name[li_i].id = ls_title
               WHEN 8
                  LET label_name[li_i].id = ls_title
               WHEN 9
                  LET label_name[li_i].id = ls_title
               WHEN 10
                  LET label_name[li_i].id = ls_title
               WHEN 11
                  LET label_name[li_i].id = ls_title
            END CASE
            LET li_i = li_i + 1
         END WHILE
 
           LET w = ui.Window.getCurrent()
           LET n = w.getNode()
           CALL p_unpack2_export_to_excel(n,base.TypeInfo.create(lr_array),'','',label_name)

END FUNCTION



FUNCTION p_unpack2_export_to_excel(n,t,t1,t2,label_name)
 
 DEFINE  t,t1,t2,n1_text,n3_text         om.DomNode,
         n,n2,n_child                    om.DomNode,
         n1,n_table,n3                   om.NodeList,
         #i,cnt_header,res,p,q,k         LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ### 
         i,res,p,q,k                     LIKE type_file.num10,    #No.FUN-690005 integer,    ### MOD-580022 ### ### TQC-690088 ###
#         h,cnt_table,cnt_cell,tmp_cnt   LIKE type_file.num10,    #No.FUN-690005 integer,    ### FUN-570216 ###
         h,cnt_cell,tmp_cnt              LIKE type_file.num10,    #No.FUN-690005 integer,    ### FUN-570216 ###
         cnt_combo_data,cnt_combo_tot    LIKE type_file.num10,    #No.FUN-690005 integer, 
         cells,values,j,l,sheet,cc       STRING, 
         table_name,field_name,l_length  STRING,     ### FUN-570128 ###
         l_table_name                    LIKE gac_file.gac05,      ### FUN-570128 ###        ### TQC-690088 ###
         l_field_name                    LIKE gac_file.gac06,      ### TQC-690088 ###
         l_datatype                      LIKE type_file.chr20,    #No.FUN-690005 VARCHAR(15),   ### FUN-570128 ###
         l_bufstr                        base.StringBuffer,
         lwin_curr                       ui.Window,
         l_show                          LIKE type_file.chr1,     #No.FUN-690005 VARCHAR(1),
         l_time                          LIKE type_file.chr8      #No.FUN-690005 VARCHAR(8)
 DEFINE  combo_arr        DYNAMIC ARRAY OF RECORD 
           sheet          LIKE type_file.num10,    #No.FUN-690005 integer,            #sheet
           seq            LIKE type_file.num10,    #No.FUN-690005 integer,            #項次
           name           LIKE type_file.chr2,     #No.FUN-690005 VARCHAR(2),            #代號
           text           LIKE type_file.chr50     #No.FUN-690005 VARCHAR(30)            #說明
                          END RECORD
 DEFINE  customize_table  LIKE type_file.chr1      #No.FUN-690005 VARCHAR(1)             ### TQC-610020 ###
 DEFINE  l_str            STRING                   ### TQC-610020 ###
 DEFINE  l_i              LIKE type_file.num5      ### TQC-610020 ###    #No.FUN-690005 SMALLINT
 DEFINE  buf              base.StringBuffer        ### FUN-660011 ###
 DEFINE  l_dec_point      STRING,                  ### FUN-670054 ###
         l_qry_name       LIKE gab_file.gab01,     ### TQC-690088 ###
         l_cust           LIKE gab_file.gab11      ### TQC-690088 ###
 DEFINE  l_tabIndex       LIKE type_file.num10                   #TQC-690124
 DEFINE  l_seq            DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 DEFINE  l_seq2           DYNAMIC ARRAY OF LIKE type_file.num10  #TQC-690124
 DEFINE  l_j              LIKE type_file.num5      #TQC-790109
 DEFINE  bFound           LIKE type_file.num5      #TQC-790109
 DEFINE  l_dbname         STRING                   #No.FUN-810062
 DEFINE  l_zal09          LIKE zal_file.zal09      #No.FUN-860089
 DEFINE  label_name        DYNAMIC ARRAY OF RECORD
               id         STRING
                          END RECORD
 
   WHENEVER ERROR CALL cl_err_msg_log             #No.FUN-860089
 
   LET cnt_table = 1  
   LET g_quote = """"    ### FUN-570128 ###

   CALL p_unpack2_get_cell_cnt(t) RETURNING tmp_cnt
   LET cnt_cell = tmp_cnt 
 
   IF t1 IS NOT NULL then
      LET cnt_table = 2 
      CALL p_unpack2_get_cell_cnt(t1) RETURNING tmp_cnt
      LET cnt_cell = cnt_cell + tmp_cnt 
   END IF   
 
   IF t2 IS NOT NULL then
      LET cnt_table = 3 
      CALL p_unpack2_get_cell_cnt(t2) RETURNING tmp_cnt
      LET cnt_cell = cnt_cell + tmp_cnt 
   END IF 
 
#   display 'cnt_cell: ',cnt_cell 
   LET l_bufstr = base.StringBuffer.create()
   WHENEVER ERROR CALL cl_err_msg_log 
   LET lwin_curr = ui.window.getCurrent()   ###MOD-530888
 
### FUN-570216 ### 
   IF cnt_table = 1 THEN
      LET l_channel = base.Channel.create()
      LET l_time = TIME(CURRENT)
      LET xls_name = g_prog CLIPPED,l_time CLIPPED,".xls"
 
      #FUN-660011
      LET buf = base.StringBuffer.create()
      CALL buf.append(xls_name)
      CALL buf.replace( ":","-", 0)
      LET xls_name = buf.toString()
      #FUN-660011
 
     #LET l_cmd = "rm ",xls_name CLIPPED," 2>/dev/null"
     #RUN l_cmd
      IF os.Path.delete(xls_name CLIPPED) THEN END IF      #FUN-980097
      CALL l_channel.openFile( xls_name CLIPPED, "a" )
      CALL l_channel.setDelimiter("")
 
      ###  TQC-5C0124 START  ###
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
      ###  TQC-5C0124 END  ###
 
      ### FUN-570128 ###
      LET l_str = "<html xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
      CALL l_channel.write(l_str CLIPPED)
      LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">"
      CALL l_channel.write(l_str CLIPPED)
      LET l_str = "xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote
      CALL l_channel.write(l_str CLIPPED)
      LET l_str = "xmlns=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote,">"
      CALL l_channel.write(l_str CLIPPED)
      CALL l_channel.write("<head><style><!--")
      #CALL l_channel.write("td  {font-family:新細明體, serif;}")  #TQC-810089 mark
      ### TQC-810089 START ###
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
      ### TQC-810089 END ###
 
      ### FUN-670054 START ###
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
      ### FUN-670054 END ###
      CALL l_channel.write(l_str CLIPPED)
      CALL l_channel.write("--></style>")
      CALL l_channel.write("<!--[if gte mso 9]><xml>")
      CALL l_channel.write("<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>")
      CALL l_channel.write("<x:DefaultRowHeight>330</x:DefaultRowHeight>")
      CALL l_channel.write("</xml><![endif]--></head>")
      ### FUN-570128 ###
      CALL l_channel.write("<body><table border=1 cellpadding=0 cellspacing=0 width=432 style='border-collapse: collapse;table-layout:fixed;width:324pt'>")
      CALL l_channel.write("<tr height=22>")          #FUN-A90047
   ELSE 
      #################
      ## start EXCEL ##
      #################
      CALL ui.Interface.frontCall("standard","shellexec",["excel"] ,res)
      CALL p_unpack2_checkError(res)
      SLEEP 2 
      CALL cl_progress_bar(cnt_cell+1)
      CALL cl_progressing("Export data to excel....")
      SLEEP 3 
   END IF 
   ### FUN-570216 ### 
 
   ### MOD-530888 ###
   #LET n = ui.Interface.getRootNode()    ##取欄位說明
   #LET n = lwin_curr.getNode()   ### FUN-870086 mark ###
   ### MOD-530888 ###
  
   ### TQC-690088 START ###
   LET l_win_name = NULL  
   LET l_win_name = n.getAttribute("name")
   IF l_win_name = "w_qry" THEN
      LET n_table = n.selectByTagName("Form")
      LET n2 = n_table.item(1)
      LET l_qry_name = n2.getAttribute("name")
      SELECT gab07,gab11 INTO g_gab07,l_cust          #FUN-6B0098
        FROM gab_file where gab01 = l_qry_name 
      IF l_cust = "" OR l_cust IS NULL THEN
         LET l_win_name = ""
      END If
      #IF STATUS THEN RETURN END IF
   END IF
   ### TQC-690088 END   ###
 
   LET n_table = n.selectByTagName("Table")
   CALL combo_arr.clear()
   FOR h=1 to cnt_table
      CALL g_hidden.clear()     ### MOD-580022 ###   
      CALL g_ifchar.clear()     ### FUN-570128 ###   
      CALL g_mask.clear()       #No.CHI-9C0051
      LET n2 = n_table.item(h)
 
      #No.FUN-860089 -- start --
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
 
      ### TQC-690088 START ###
      #IF l_win_name = "w_qry" AND g_gab07 = "N" THEN         #FUN-6B0098
      CASE
         WHEN l_win_name = "w_qry" AND g_gab07 = "N"          #FUN-6B0098
              SELECT count(*) into cnt_header FROM gac_file 
               WHERE gac01=l_qry_name AND gac12=l_cust 
              LET cnt_header = cnt_header + 1
         OTHERWISE
            LET cnt_header = n1.getLength()
      END CASE 
      #No.FUN-860089 -- end --
      ### TQC-690088 END ###
      LET l = h
      LET sheet="Sheet" CLIPPED,l
      LET cnt_combo_data = 0       ###該comboBox資料的個數
      LET cnt_combo_tot = 0   ###總comboBox資料的個數
      ### FUN-570216 START ### 
      IF cnt_table <> 1 THEN
         CALL ui.Interface.frontCall("WINDDE","DDEConnect", ["EXCEL",Sheet], res)
         CALL p_unpack2_checkError(res)
         #DISPLAY res
      END IF
      ### FUN-570216 END ### 
      LET k = 0                       ### MOD-580022 ### 
 
      #TQC-690124
      #FOR i=1 to cnt_header
      #   LET n1_text = n1.item(i)
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
      #END TQC-690124
         #LET j = i                   ### MOD-580022 ###
         LET k = k + 1                ### MOD-580022 ###
         LET j = k                    ### MOD-580022 ###
         LET cells = "R1C" CLIPPED,j
         #################### 
         ### Get comboBox ###
         ####################
         LET n3 = "" 
         LET n3 = n1_text.selectByPath("/TableColumn/ComboBox/Item")
         IF n3 is not NULL THEN
            LET cnt_combo_data = n3.getLength()
            FOR p = 1 to cnt_combo_data
               LET combo_arr[p+cnt_combo_tot].sheet = h 
               LET combo_arr[p+cnt_combo_tot].seq = i
               LET n3_text=n3.item(p)          
               LET combo_arr[p+cnt_combo_tot].name=n3_text.getAttribute("name")
               LET combo_arr[p+cnt_combo_tot].text=n3_text.getAttribute("text")
            END FOR
            LET cnt_combo_tot=cnt_combo_tot+p
         END IF
         
         #### MOD-530888 ####
         LET l_show = n1_text.getAttribute("hidden")
         IF l_show = "0" OR l_show IS NULL THEN  ###MOD-560298
            LET values = n1_text.getAttribute("text")
            LET values = label_name[j].id
            #LET field_name = n1_text.getAttribute("name")  #No.CHI-9C0051  #FUN-A10046 mask by tommas
         #### FUN-570128 ####
            IF cnt_table = 1 THEN
               IF (l_win_name <> "w_qry") OR (l_win_name IS NULL) OR  ### TQC-690088 ###
                  (l_win_name = "w_qry" AND g_gab07 != "N" )       #FUN-6B0098
               THEN
                  LET customize_table = 0      ### TQC-610020 ### 
                  LET field_name = n1_text.getAttribute("name")
                  #display "field_name :",field_name
                  IF field_name.getIndexOf(".",1) <> 0 THEN
                     LET tmp_cnt = field_name.getIndexOf(".",1) 
                     LET field_name = field_name.subString(tmp_cnt+1, LENGTH(field_name))    
                     ### TQC-610020 START ###
                     IF field_name.getIndexOf("ta_",1) <> 0 THEN
                        IF field_name.getIndexOf("_",4) <> 0 THEN
                           LET tmp_cnt = field_name.getIndexOf("_",4)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     END IF 
                     IF field_name.getIndexOf("tc_",1) <> 0 THEN
                        LET customize_table = 1
                        IF field_name.getIndexOf("_",4) <> 0 THEN
                           LET tmp_cnt = field_name.getIndexOf("_",4)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     ELSE 
                        IF (field_name.getIndexOf("_",1) <> 0) and (field_name.getIndexOf("ta_",1) = 0) THEN
                           LET tmp_cnt = field_name.getIndexOf("_",1)
                           LET field_name = field_name.subString(1, tmp_cnt-1)    
                        END IF
                     END IF
                  END IF 
                  LET l_str =  field_name.subString(LENGTH(field_name)-3,LENGTH(field_name))
                  IF (l_str = "acti") or (l_str = "date") or (l_str = "grup") or 
                     (l_str = "modu") or (l_str = "user") or (l_str = "slip") or
                     #(l_str = "mksg")                              #TQC-690124           
                     (l_str = "mksg") or (l_str.subString(1,2) = "ud")   #CHI-A40060 
                  THEN
                     LET table_name = field_name.subString(1,LENGTH(field_name)-4),"_file"
                  ELSE
                     FOR l_i = 1 TO LENGTH(field_name) 
                        IF field_name.subString(l_i,l_i) MATCHES "[0123456789]" THEN
                           EXIT FOR
                        END IF
                     END FOR
                     LET table_name = field_name.subString(1,l_i-1),"_file"
                  END IF
                  IF table_name.getIndexOf("ta_",1) <> 0 THEN
                     LET table_name = table_name.subString(4, LENGTH(table_name))    
                  END IF
                  ### TQC-610020 END ###
                  LET l_table_name = table_name
                  LET l_field_name = field_name

               ### TQC-690088 START ###
               ELSE  
                  IF i <> 1 THEN 
                     SELECT gac05,gac06 into l_table_name,l_field_name FROM gac_file 
                      WHERE gac01=l_qry_name AND gac12=l_cust AND gac02=i-1
                  END IF
               END IF
               ### TQC-690088 END ###
               #No.FUN-810062
               CASE cl_db_get_database_type()
                 WHEN "MSV"
                    LET l_dbname =  FGL_GETENV('MSSQLAREA'),'_ds'
                 OTHERWISE
                    LET l_dbname = 'ds'
               END CASE
               CALL cl_get_column_info(l_dbname,l_table_name,l_field_name) RETURNING l_datatype,l_length
               #END No.FUN-810062
               #display "table:",l_table_name,"field:",l_field_name,"type:",
               #                 l_datatype,"length:",l_length
               IF l_datatype = "varchar2" OR l_datatype = "char" OR 
                  l_datatype = "date" OR l_datatype="datetime"       #No.FUN-810062
               THEN
                  LET g_ifchar[i] = "1"
               ### FUN-670054 START ###
               ELSE  
                  IF l_datatype = "number" OR l_datatype = "decimal" THEN
                     LET l_dec_point = l_length.substring(l_length.getIndexOf(",",1)+1,l_length.getlength())                     
                     IF l_dec_point = "1" THEN ## 1被字串用了,用A取代 ##
                        LET g_ifchar[i] = "A"
                     ELSE
                        IF l_dec_point = "10" THEN ##最多只會有10位小數 ##
                           LET g_ifchar[i] = "B"
                        ELSE
                           LET g_ifchar[i] = l_dec_point 
                        END IF
                     END IF
                  END IF
               ### FUN-670054 END ###
               END IF
            END IF
            #### FUN-570128 ####
            CALL l_bufstr.clear()
            CALL l_bufstr.append(values)
            CALL l_bufstr.replace("+","'+",0)
            CALL l_bufstr.replace("-","'-",0)
            CALL l_bufstr.replace("=","'=",0)
            LET values = l_bufstr.tostring()
            #DISPLAY sheet,cells,values

          #### CHI-9C0051 START ####
#            IF chk_mask(field_name) THEN   #FUN-A10046  mask by tommas
            IF p_unpack2_chk_mask(n1_text) THEN       #FUN-A10046  add by tommas
               LET g_mask[i] = "1"
            END IF
          #### CHI-9C0051 END   ###

            ### FUN-570216 ###
            IF cnt_table = 1 THEN
               LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
               CALL l_channel.write(l_str CLIPPED)
            ELSE
               CALL ui.Interface.frontCall("WINDDE","DDEPoke", ["EXCEL",sheet,cells,values], [res]);
               CALL p_unpack2_checkError(res)
            END IF
         ### FUN-570216 ###
         ELSE    ### MOD-580022 ###
            LET g_hidden[i] = "1"
            LET k = k -1  
         END IF
      ### MOD-530888 ###
      END FOR
      ##TQC-690124
      IF h=1 THEN CALL p_unpack2_get_body(h,cnt_header,t,combo_arr,l_seq) END IF
      IF h=2 THEN CALL p_unpack2_get_body(h,cnt_header,t1,combo_arr,l_seq) END IF
      IF h=3 THEN CALL p_unpack2_get_body(h,cnt_header,t2,combo_arr,l_seq) END IF
      ##END TQC-690124
 
   END FOR
END FUNCTION

#No:FUN-B50137
##################################################
# Private Func...: TRUE
# Descriptions...: 匯出excel時，以畫面檔的isPassword為隱藏條件
# Date & Author..: 10/01/11 By Tommas
# Input parameter: n1_text  DomNode節點
# Return code....: Boolean
# Modify ........: 
##################################################
FUNCTION p_unpack2_chk_mask(n1_text)   #No.FUN-A10046
   DEFINE n1_text        om.DomNode
   DEFINE n1             om.DomNode
   
   LET n1 = n1_text.getFirstChild()
   IF n1.getAttribute("isPassword") = "1" THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION

# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: s
# Return code....: cnt           
 
FUNCTION p_unpack2_get_cell_cnt(s)
 DEFINE  s           om.DomNode,
         n1          om.NodeList,
         cnt         LIKE type_file.num10     #No.FUN-690005 integer
 
   LET n1 = s.selectByTagName("Field")
   LET cnt = n1.getLength()
   RETURN cnt
END FUNCTION
 
# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: 
# Return code....:            
FUNCTION p_unpack2_get_body(p_h,p_cnt_header,s,s_combo_arr,p_seq)  ##TQC-690124
 DEFINE  s,n1_text                          om.DomNode,
         n1                                 om.NodeList,
         i,m,k,cnt_body,res,p               LIKE type_file.num10,    #No.FUN-690005 integer,
         l_hidden_cnt,n,l_last_hidden       LIKE type_file.num10,    #No.FUN-690005 integer,  ### MOD-580022 ###
         p_h,p_cnt_header,arr_len           LIKE type_file.num10,    #No.FUN-690005 integer,
         p_null                             LIKE type_file.num10,    ### TQC-690088 ###
         cells,values,j,l,sheet             STRING,
         l_bufstr                           base.StringBuffer
 
 DEFINE  s_combo_arr    DYNAMIC ARRAY OF RECORD
          sheet         LIKE type_file.num10,    #No.FUN-690005 integer,       #sheet
          seq           LIKE type_file.num10,    #No.FUN-690005 integer,       #項次
          name          LIKE type_file.chr2,     #No.FUN-690005 VARCHAR(2),       #代號
          text          LIKE type_file.chr50     #No.FUN-690005 VARCHAR(30)       #說明
                        END RECORD
 DEFINE  p_seq          DYNAMIC ARRAY OF LIKE type_file.num10 #TQC-690124    #FUN-6B0098
 DEFINE  l_item         LIKE type_file.num10     #TQC-690124     #FUN-6B0098
 
 DEFINE  unix_path      STRING,                  #FUN-660011
         window_path    STRING                   #FUN-660011
 DEFINE  l_dom_doc      om.DomDocument,          ### TQC-690088 ###
         r,n_node       om.DomNode               ### TQC-690088 ###  
 DEFINE  l_status       LIKE type_file.num5      #No.FUN-860089
 
   #No.FUN-860089 -- start --   
   #使用 Table 動態排序功能，則資料需要重新排序
   IF NOT cl_null(g_sort.column) AND g_sort.column >=0 THEN 
      display "sort start:",time
      CALL p_unpack2_body_set_sort(p_cnt_header,s) RETURNING l_status,s
      display "sort end:",time
      IF l_status THEN 
         RETURN 
      END IF
   END IF
   #No.FUN-860089 -- end --   
 
   LET l_hidden_cnt = 0  ### MOD-580022 ###      
   LET l = p_h
   LET sheet="Sheet" CLIPPED,l
   LET l_bufstr = base.StringBuffer.create()
   ### TQC-690088 START ###
   #IF l_win_name = "w_qry" AND g_gab07 = "N" THEN          #FUN-6B0098
   IF (l_win_name = "w_qry" AND g_gab07 = "N" ) OR
      (l_win_name = "p_dbqry_table") OR 
      (l_win_name <> "query_w" AND NOT cl_null(g_sort.column) AND g_sort.column >=0 )   #No.FUN-860089 
   THEN      
      LET n1 = s.selectByTagName("Record")
      LET n1_text = n1.item(1)
      LET n1=n1_text.selectByTagName("Field")
      LET m = n1.getLength()
      LET n1 = s.selectByTagName("Field")
 
      LET l_dom_doc = om.DomDocument.create("qrydata")
      LET r = l_dom_doc.getDocumentElement()
      FOR i=1 to n1.getLength()
         LET n1_text = n1.item(i)
         #IF n1_text.getAttributeString("value","")<>"def" THEN
         LET k = i mod m 
         IF (k <= cnt_header) AND (k<>0) THEN 
            LET n_node = r.createChild("Field")
            CALL n_node.setAttribute("value",n1_text.getAttribute("value"))
         END IF
      END FOR
      CALL r.writeXML("test.xml")
      LET n1 = r.selectByTagName("Field")
   ELSE
      LET n1 = s.selectByTagName("Field")
   END IF
   LET l = 0
   LET i = 0 
   LET m = 0
   ### TQC-690088 END ###
 
   FOR i=1 to n1.getLength()
      ### FUN-570216 ### 
      IF cnt_table > 1 THEN
         CALL cl_progressing("Export data to excel....")    ### MOD-580022 ###
      END IF
      ### FUN-570216 ### 
 
      #LET n1_text = n1.item(i) #TQC-690124
 
      LET k = i MOD p_cnt_header
      LET m = i / p_cnt_header + 2  ##還有header
      IF k = 0 then
         LET k = p_cnt_header
         LET m = m - 1
      END IF
 
      #TQC-690124
      LET p = i / p_cnt_header
      IF k = p_cnt_header THEN 
         LET p = p - 1
      END IF
      LET l_item = p * p_cnt_header + p_seq[k]
      LET n1_text = n1.item(l_item)
      #END TQC-690124
 
      ### MOD-580022 ###
      IF g_hidden.getLength() > 0 THEN
         LET l_hidden_cnt=0
         FOR n=1 TO k
            IF g_hidden[n]=1 THEN
               LET l_hidden_cnt = l_hidden_cnt + 1    
               LET l_last_hidden = n
            END IF 
         END FOR
         IF (l_hidden_cnt > 0) AND (l_last_hidden = k) THEN 
            CONTINUE FOR 
         END IF
      END IF 
      LET l = k - l_hidden_cnt 
 ### MOD-580022 ###      
      LET j = m
      LET cells = "R",j,"C",l
 
      LET values = n1_text.getAttribute("value")

      IF cl_null(values) then
         LET values=" "
      ELSE    ###combo一定有值
         CALL l_bufstr.clear()
         CALL l_bufstr.append(values)
         CALL l_bufstr.replace("\n",",",0)
         LET values = l_bufstr.tostring()
         LET arr_len = s_combo_arr.getLength()
         #LET l = arr_len
         #display "s_combo_arr len= ",l         
         IF arr_len<>0 THEN
            FOR p = 1 to arr_len
               IF (s_combo_arr[p].sheet = p_h) AND (s_combo_arr[p].seq=k) AND (s_combo_arr[p].name=values) THEN
                  LET values = s_combo_arr[p].text
               END IF        
            END FOR 
         END IF 
      END IF

      ####  CHI-9C0051  START ####
      IF g_mask[k] IS NOT NULL THEN
         LET values = "●●●"
      END IF
      ####  CHI-9C0051  END   ####

### FUN-570216 ###
      IF cnt_table = 1 THEN
         IF l = "1" THEN
            CALL l_channel.write("</tr><tr height=22>")    #FUN-A90047
         END IF    
     ### FUN-570128 ###
         ### FUN-670054 START ### 
         IF g_ifchar[k] is null THEN
            LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
         ELSE
            IF g_ifchar[k] = "1" THEN
               #TQC-6A0067
               IF FGL_WIDTH(values) > 255 THEN
                    LET l_str = "<td>",cl_add_span(values),"</td>"    #FUN-A20036
               ELSE
                    LET l_str = "<td class=xl24>",cl_add_span(values),"</td>"     #FUN-A20036
               END IF
               #END TQC-6A0067
            ELSE 
               IF g_ifchar[k] = "A" THEN ## 1被字串用了,用A取代 ##
                  LET l_str = "<td class=xl31>",values,"</td>"
               ELSE
                  IF g_ifchar[k] = "10" THEN ##最多只會有10位小數 ##
                     LET l_str = "<td class=xl40>",values,"</td>"
                  ELSE
                     LET l_str = "<td class=xl3",g_ifchar[k] USING '<<<<<<<<<<',">",values,"</td>"
                  END IF
               END IF
            END IF
         ### FUN-670054 END ### 
         END IF
     ### FUN-570128 ###
         CALL l_channel.write(l_str CLIPPED)
      ELSE 
        CALL ui.Interface.frontCall("WINDDE","DDEPoke", ["EXCEL",Sheet,cells,values], [res])
        CALL p_unpack2_checkError(res)
      END IF
### FUN-570216 ###
   END FOR
### FUN-570216 ###
   IF cnt_table = 1 THEN
      CALL l_channel.write("</tr></table></body></html>")
      CALL l_channel.close()
    ###  TQC-5C0124 START  ###
      CALL cl_prt_convert(xls_name)  ### TQC-5C0124 ###
      #IF tsconv_cmd IS NULL THEN
      #   LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED,".ts"
      #ELSE
#FUN-660011
      #  LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
      #END IF
    ###  TQC-5C0124 END  ###
 
      #CALL ui.Interface.frontCall("standard",
      #                         "shellexec",
      #                         ["EXPLORER \"" || l_str || "\""],
      #                         [res])
      #IF STATUS THEN
      #   CALL cl_err("Front End Call failed.", STATUS, 1)
      #   RETURN
      #END IF
      # IF cl_null(g_aza.aza56) THEN
      #   UPDATE aza_file set aza56='1'
      #   IF SQLCA.sqlcode THEN
      #           #CALL cl_err('U',SQLCA.sqlcode,0)
      #           CALL cl_err3("upd","aza_file","1","",SQLCA.sqlcode,"","",0)   #No.FUN-640161
      #           RETURN
      #   END IF
      #   LET g_aza.aza56 = '1'
      # END IF
 
      # IF g_aza.aza56 = '2' THEN
           #LET unix_path = "$TEMPDIR/",xls_name CLIPPED
      #      LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)   #FUN-980097
 
      #      LET window_path = "c:\\tiptop\\",xls_name CLIPPED
      #      LET status = cl_download_file(unix_path, window_path)
      #      IF status then
      #         DISPLAY "Download OK!!"
      #      ELSE
      #         DISPLAY "Download fail!!"
      #      END IF
 
      #      LET status = cl_open_prog("excel",window_path)
      #      IF status then
      #         DISPLAY "Open OK!!"
      #      ELSE
      #         DISPLAY "Open fail!!"
      #      END IF
      # ELSE
            #FUN-980097 此處為組出 URL Address,不需代換
      #      LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
      #      CALL ui.Interface.frontCall("standard",
      #                               "shellexec",
      #                               ["EXPLORER \"" || l_str || "\""],
      #                               [res])
      #      IF STATUS THEN
      #         CALL cl_err("Front End Call failed.", STATUS, 1)
      #         RETURN
      #      END IF
      # END IF
#END FUN-660011
   ELSE
      CALL ui.Interface.frontCall("WINDDE","DDEFinish", ["EXCEL",Sheet], [res] )
      CALL p_unpack2_checkError(res)
   END IF
### FUN-570216 ###
END FUNCTION
                                                                    
                                                                                                
### MOD-AA0168 START ###                                                                        
# Private Func...: TRUE                                                                         
# Descriptions...: 使用 Table 動態排序功能，則資料需要重新排序                                  
# Memo...........:                                                                              
# Input parameter:                                                                              
# Return code....:                                                                              
FUNCTION p_unpack2_body_set_sort(p_cnt_header,s)                                                       
   DEFINE s                    om.DomNode               #報表資料                               
   DEFINE p_cnt_header         LIKE type_file.num10     #欄位個數                               
   DEFINE n_field              om.DomNode,                                                      
          n_record             om.DomNode,                                                      
          nl_record            om.NodeList,                                                     
          nl_field             om.NodeList                                                      
   DEFINE l_i                  LIKE type_file.num10                                             
   DEFINE l_j                  LIKE type_file.num10                                             
   DEFINE l_value              STRING                                                           
   DEFINE l_sql                STRING                                                           
   DEFINE l_pid                LIKE gdn_file.gdn01                                 
   DEFINE l_gdn         RECORD LIKE gdn_file.*                                   
   DEFINE l_gdn1        RECORD LIKE gdn_file.*                                    
   DEFINE sr            DYNAMIC ARRAY OF RECORD                                                
      field001, field002, field003, field004, field005, field006, field007,                     
      field008, field009, field010, field011, field012, field013, field014,                     
      field015, field016, field017, field018, field019, field020, field021,                     
      field022, field023, field024, field025, field026, field027, field028,                     
      field029, field030, field031, field032, field033, field034, field035,                     
      field036, field037, field038, field039, field040, field041, field042,                     
      field043, field044, field045, field046, field047, field048, field049,                     
      field050, field051, field052, field053, field054, field055, field056,                     
      field057, field058, field059, field060, field061, field062, field063,                     
      field064, field065, field066, field067, field068, field069, field070,                     
      field071, field072, field073, field074, field075, field076, field077,                     
      field078, field079, field080, field081, field082, field083, field084,                     
      field085, field086, field087, field088, field089, field090, field091,                     
      field092, field093, field094, field095, field096, field097, field098,                     
      field099, field100  LIKE gaq_file.gaq05                                        
                               END RECORD                                                       
   DEFINE l_bufstr             base.StringBuffer                                  
                                                                                                
   LET l_pid = FGL_GETPID()                                                     
   LET l_bufstr = base.StringBuffer.create()                                     
                                                                                                
   #抓取資料並將資料存至 table   
   display "save table:",time                                                               
   LET nl_record = s.selectByTagName("Record")                                                  
   display "select by tag table:",time                                                               

   FOR l_i=1 to nl_record.getLength()                                                           
       LET n_record = nl_record.item(l_i)                                                       
       LET nl_field=n_record.selectByTagName("Field")                                           
       FOR l_j = 1 TO p_cnt_header                                                              
           LET l_sql = "INSERT INTO gdn_file VALUES("                           
           LET n_field = nl_field.item(l_j)                                                     
           LET l_value = n_field.getAttribute("value")                                          
                                                                                                
           CALL l_bufstr.clear()                                                                
           CALL l_bufstr.append(l_value)                                                        
           CALL l_bufstr.replace("\n",",",0)                                                    
           CALL l_bufstr.replace('\'','\'\'',0)                                                 
           LET l_value = l_bufstr.tostring()                                                    
                                                                                                
           LET l_sql = l_sql,l_pid,",",l_i,",",l_j,",'",l_value CLIPPED,"')"                    
           EXECUTE IMMEDIATE l_sql                                                              
           IF SQLCA.SQLCODE THEN                                                                
              CALL cl_err("insert gdn_file:",SQLCA.SQLCODE,1)                    
              RETURN 1,s                                                                        
           END IF                                                                               
       END FOR                                                                                  
   END FOR                                                                                      
                                                                                                
   #重新讀取排序後的資料    
   #display "order table:",time                                                               
   CALL sr.clear()                                                                              
   #EX:select gdn04 from gdn_file where gdn03=2 order by gdn04;                                 
   LET l_sql = "SELECT gdn01,gdn02,gdn03,gdn04 FROM gdn_file WHERE gdn01=",l_pid,               
               " AND gdn03=",g_sort.column CLIPPED,                                             
               " ORDER BY gdn04 ",g_sort.type CLIPPED                                           
   #display l_sql                                                                                
   PREPARE table_pre FROM l_sql                                                                 
   DECLARE table_cur CURSOR FOR table_pre                                                       
   IF SQLCA.SQLCODE THEN                                                                        
      CALL cl_err('table_cur',sqlca.sqlcode,1)                                                  
      RETURN 1,s                                                                                
   END IF                                                                                       
   LET l_i = 1                                                                                  
   FOREACH table_cur INTO l_gdn.*                                                               
      #display "l_gdn.gdn04:",l_gdn.gdn04                                                        
      LET l_sql = "SELECT gdn03,gdn04 FROM gdn_file WHERE gdn01=",l_gdn.gdn01,                  
                  " AND gdn02=",l_gdn.gdn02," ORDER BY gdn03"                                   
      PREPARE gdn_pre FROM l_sql                                                                
      DECLARE gdn_cur CURSOR FOR gdn_pre                                                        
      IF SQLCA.SQLCODE THEN                                                                     
         CALL cl_err('gdn_cur',sqlca.sqlcode,1)                                                 
         RETURN 1,s                                                                             
      END IF                                                                                    
      FOREACH gdn_cur INTO l_gdn1.gdn03,l_gdn1.gdn04                                            
         CASE l_gdn1.gdn03                                                                      
            WHEN   1 LET sr[l_i].field001 = l_gdn1.gdn04                                        
            WHEN   2 LET sr[l_i].field002 = l_gdn1.gdn04                                        
            WHEN   3 LET sr[l_i].field003 = l_gdn1.gdn04                                        
            WHEN   4 LET sr[l_i].field004 = l_gdn1.gdn04                                        
            WHEN   5 LET sr[l_i].field005 = l_gdn1.gdn04                                        
            WHEN   6 LET sr[l_i].field006 = l_gdn1.gdn04                                        
            WHEN   7 LET sr[l_i].field007 = l_gdn1.gdn04                                        
            WHEN   8 LET sr[l_i].field008 = l_gdn1.gdn04                                        
            WHEN   9 LET sr[l_i].field009 = l_gdn1.gdn04                                        
            WHEN  10 LET sr[l_i].field010 = l_gdn1.gdn04                                        
            WHEN  11 LET sr[l_i].field011 = l_gdn1.gdn04                                        
            WHEN  12 LET sr[l_i].field012 = l_gdn1.gdn04                                        
            WHEN  13 LET sr[l_i].field013 = l_gdn1.gdn04                                        
            WHEN  14 LET sr[l_i].field014 = l_gdn1.gdn04                                        
            WHEN  15 LET sr[l_i].field015 = l_gdn1.gdn04                                        
            WHEN  16 LET sr[l_i].field016 = l_gdn1.gdn04                                        
            WHEN  17 LET sr[l_i].field017 = l_gdn1.gdn04                                        
            WHEN  18 LET sr[l_i].field018 = l_gdn1.gdn04                                        
            WHEN  19 LET sr[l_i].field019 = l_gdn1.gdn04                                        
            WHEN  20 LET sr[l_i].field020 = l_gdn1.gdn04                                        
            WHEN  21 LET sr[l_i].field021 = l_gdn1.gdn04                                        
            WHEN  22 LET sr[l_i].field022 = l_gdn1.gdn04                                        
            WHEN  23 LET sr[l_i].field023 = l_gdn1.gdn04                                        
            WHEN  24 LET sr[l_i].field024 = l_gdn1.gdn04                                        
            WHEN  25 LET sr[l_i].field025 = l_gdn1.gdn04                                        
            WHEN  26 LET sr[l_i].field026 = l_gdn1.gdn04                                        
            WHEN  27 LET sr[l_i].field027 = l_gdn1.gdn04                                        
            WHEN  28 LET sr[l_i].field028 = l_gdn1.gdn04                                        
            WHEN  29 LET sr[l_i].field029 = l_gdn1.gdn04                                        
            WHEN  30 LET sr[l_i].field030 = l_gdn1.gdn04                                        
            WHEN  31 LET sr[l_i].field031 = l_gdn1.gdn04                                        
            WHEN  32 LET sr[l_i].field032 = l_gdn1.gdn04                                        
            WHEN  33 LET sr[l_i].field033 = l_gdn1.gdn04                                        
            WHEN  34 LET sr[l_i].field034 = l_gdn1.gdn04                                        
            WHEN  35 LET sr[l_i].field035 = l_gdn1.gdn04                                        
            WHEN  36 LET sr[l_i].field036 = l_gdn1.gdn04                                        
            WHEN  37 LET sr[l_i].field037 = l_gdn1.gdn04                                        
            WHEN  38 LET sr[l_i].field038 = l_gdn1.gdn04                                        
            WHEN  39 LET sr[l_i].field039 = l_gdn1.gdn04                                        
            WHEN  40 LET sr[l_i].field040 = l_gdn1.gdn04                                        
            WHEN  41 LET sr[l_i].field041 = l_gdn1.gdn04                                        
            WHEN  42 LET sr[l_i].field042 = l_gdn1.gdn04                                        
            WHEN  43 LET sr[l_i].field043 = l_gdn1.gdn04                                        
            WHEN  44 LET sr[l_i].field044 = l_gdn1.gdn04                                        
            WHEN  45 LET sr[l_i].field045 = l_gdn1.gdn04                                        
            WHEN  46 LET sr[l_i].field046 = l_gdn1.gdn04                                        
            WHEN  47 LET sr[l_i].field047 = l_gdn1.gdn04                                        
            WHEN  48 LET sr[l_i].field048 = l_gdn1.gdn04                                        
            WHEN  49 LET sr[l_i].field049 = l_gdn1.gdn04                                        
            WHEN  50 LET sr[l_i].field050 = l_gdn1.gdn04                                        
            WHEN  51 LET sr[l_i].field051 = l_gdn1.gdn04                                        
            WHEN  52 LET sr[l_i].field052 = l_gdn1.gdn04                                        
            WHEN  53 LET sr[l_i].field053 = l_gdn1.gdn04                                        
            WHEN  54 LET sr[l_i].field054 = l_gdn1.gdn04                                        
            WHEN  55 LET sr[l_i].field055 = l_gdn1.gdn04                                        
            WHEN  56 LET sr[l_i].field056 = l_gdn1.gdn04                                        
            WHEN  57 LET sr[l_i].field057 = l_gdn1.gdn04                                        
            WHEN  58 LET sr[l_i].field058 = l_gdn1.gdn04                                        
            WHEN  59 LET sr[l_i].field059 = l_gdn1.gdn04                                        
            WHEN  60 LET sr[l_i].field060 = l_gdn1.gdn04                                        
            WHEN  61 LET sr[l_i].field061 = l_gdn1.gdn04                                        
            WHEN  62 LET sr[l_i].field062 = l_gdn1.gdn04                                        
            WHEN  63 LET sr[l_i].field063 = l_gdn1.gdn04                                        
            WHEN  64 LET sr[l_i].field064 = l_gdn1.gdn04                                        
            WHEN  65 LET sr[l_i].field065 = l_gdn1.gdn04                                        
            WHEN  66 LET sr[l_i].field066 = l_gdn1.gdn04                                        
            WHEN  67 LET sr[l_i].field067 = l_gdn1.gdn04                                        
            WHEN  68 LET sr[l_i].field068 = l_gdn1.gdn04                                        
            WHEN  69 LET sr[l_i].field069 = l_gdn1.gdn04                                        
            WHEN  70 LET sr[l_i].field070 = l_gdn1.gdn04                                        
            WHEN  71 LET sr[l_i].field071 = l_gdn1.gdn04                                        
            WHEN  72 LET sr[l_i].field072 = l_gdn1.gdn04                                        
            WHEN  73 LET sr[l_i].field073 = l_gdn1.gdn04                                        
            WHEN  74 LET sr[l_i].field074 = l_gdn1.gdn04                                        
            WHEN  75 LET sr[l_i].field075 = l_gdn1.gdn04                                        
            WHEN  76 LET sr[l_i].field076 = l_gdn1.gdn04                                        
            WHEN  77 LET sr[l_i].field077 = l_gdn1.gdn04                                        
            WHEN  78 LET sr[l_i].field078 = l_gdn1.gdn04                                        
            WHEN  79 LET sr[l_i].field079 = l_gdn1.gdn04                                        
            WHEN  80 LET sr[l_i].field080 = l_gdn1.gdn04                                        
            WHEN  81 LET sr[l_i].field081 = l_gdn1.gdn04                                        
            WHEN  82 LET sr[l_i].field082 = l_gdn1.gdn04                                        
            WHEN  83 LET sr[l_i].field083 = l_gdn1.gdn04                                        
            WHEN  84 LET sr[l_i].field084 = l_gdn1.gdn04                                        
            WHEN  85 LET sr[l_i].field085 = l_gdn1.gdn04                                        
            WHEN  86 LET sr[l_i].field086 = l_gdn1.gdn04                                        
            WHEN  87 LET sr[l_i].field087 = l_gdn1.gdn04                                        
            WHEN  88 LET sr[l_i].field088 = l_gdn1.gdn04                                        
            WHEN  89 LET sr[l_i].field089 = l_gdn1.gdn04                                        
            WHEN  90 LET sr[l_i].field090 = l_gdn1.gdn04                                        
            WHEN  91 LET sr[l_i].field091 = l_gdn1.gdn04                                        
            WHEN  92 LET sr[l_i].field092 = l_gdn1.gdn04                                        
            WHEN  93 LET sr[l_i].field093 = l_gdn1.gdn04                                        
            WHEN  94 LET sr[l_i].field094 = l_gdn1.gdn04                                        
            WHEN  95 LET sr[l_i].field095 = l_gdn1.gdn04                                        
            WHEN  96 LET sr[l_i].field096 = l_gdn1.gdn04                                        
            WHEN  97 LET sr[l_i].field097 = l_gdn1.gdn04                                        
            WHEN  98 LET sr[l_i].field098 = l_gdn1.gdn04                                        
            WHEN  99 LET sr[l_i].field099 = l_gdn1.gdn04                                        
            WHEN 100 LET sr[l_i].field100 = l_gdn1.gdn04                                        
         END CASE                                                                               
      END FOREACH                                                                               
      LET l_i = l_i + 1                                                                         
   END FOREACH  
                                                                                   
   #display "finish order table:",time                                                               
   CALL sr.deleteElement(l_i)                                                                   
                                                                                                
   DELETE FROM gdn_file WHERE gdn01 = l_pid                                                     
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                                                  
      CALL cl_err3("del","gdn_file",l_pid,"",SQLCA.sqlcode,"","",0)                             
   END IF                                                                                       
                                                                                                
   RETURN 0,base.TypeInfo.create(sr)                                                            
END FUNCTION                                                                                    
### MOD-AA0168 END ###                                                                          

# Private Func...: TRUE
# Descriptions...:
# Memo...........:
# Input parameter: 
# Return code....:            
FUNCTION p_unpack2_checkError(res)
   DEFINE res  LIKE type_file.num10    #No.FUN-690005 INTEGER
   DEFINE mess STRING
   IF res THEN RETURN END IF
   DISPLAY "DDE Error:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[mess]);
   DISPLAY mess
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll", [], [res] );
   DISPLAY "Exit with DDE Error."
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B70007
   EXIT PROGRAM (-1)
END FUNCTION

