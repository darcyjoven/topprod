# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi400.4gl
# Descriptions...: 
# Date & Author..: 05/12/02 By vivien
# Modify.........: NO.TQC-640126 06/04/10 By vivien 報表打印調整
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier atmr400時傳入g_bgjob='Y'
# Modify.........: No.FUN-870100 09/06/01 BY lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A40081 10/05/05 By chenying 新增g_argv1='25',g_argv1='26'
# Modify.........: NO.FUN-A60044 10/06/13 By Cockroach 新增價格代碼維護作業arti423,tqa03='27'
#                                                      new column 開始價格tqa05，結束價格tqa06
# Modify.........: NO.FUN-A60066 10/07/10 By bnlent 新增tqapos
# Modify.........: NO.FUN-A70063 10/07/12 By chenying 新增tqa07,tqa02_n1,tqa08,tqa02_n2
#                                                     新增i402_tqa07(p_tqa01,p_tqa07),以遞迴的方式檢查tqa07合理性;
#                                                     新增g_argv1='28',新增i400_tqa07(p_cmd),新增i400_tqa08(p_cmd)
# Modify.........: NO:FUN-AA0071 10/10/25 By chenying 手動清空 tqa08 欄位值, After Field將 tqa02_n2 欄位清空
# Modify.........: No:FUN-B40071 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B50006 11/05/03 by rainy 新增專櫃抽成KEY
# Modify.........: No:FUN-B80141 11/08/24 by shiwuying 新增摊位用途
# Modify.........: No:FUN-B90056 11/09/06 by nanbing 新增31意向品牌，32品牌等級，33商戶等級
#                                                    新增品牌等級tqa09和品牌等級說明tqa02
# Modify.........: No:FUN-B70075 11/10/25 By nanbing 更新已传pos否的状态
# Modify.........: No:MOD-C60207 12/06/25 By Vampire 修正FUN-A60044修改歷程,將artt423修正為arti423
# Modify.........: No:MOD-D10232 13/01/25 By Sakura  刪除語法新增代碼類別(tqa03)條件 
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_argv1         LIKE tqa_file.tqa03,   
    g_tqa03         LIKE tqa_file.tqa03,
    g_tqa03_t       LIKE tqa_file.tqa03,
    g_tqa           DYNAMIC ARRAY OF RECORD        #程式變數(Program Variables)
        tqa01       LIKE tqa_file.tqa01,           #代碼編號
        tqa02       LIKE tqa_file.tqa02,           #說明
        tqa04       LIKE tqa_file.tqa04,           #FUN-870100
        tqa05       LIKE tqa_file.tqa05,           #FUN-A60044
        tqa06       LIKE tqa_file.tqa06,           #FUN-A60044
        tqa07       LIKE tqa_file.tqa07,           #FUN-A70063
        tqa02_n1    LIKE tqa_file.tqa02,           #FUN-A70063
        tqa08       LIKE tqa_file.tqa08,           #FUN-A70063
        tqa02_n2    LIKE tqa_file.tqa02,           #FUN-A70063
        tqa09       LIKE tqa_file.tqa09,           #FUN-B90056
        tqa02_n3    LIKE tqa_file.tqa02,           #FUN-B90056
        tqaacti     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1) 
        tqapos      LIKE tqa_file.tqapos           #No.FUN-A60066 VARCHAR(1) 
                    END RECORD,
    g_tqa_t         RECORD                         #程式變數 (舊值)
        tqa01       LIKE tqa_file.tqa01,           #代碼編號
        tqa02       LIKE tqa_file.tqa02,           #說明
        tqa04       LIKE tqa_file.tqa04,           #FUN-870100
        tqa05       LIKE tqa_file.tqa05,           #FUN-A60044
        tqa06       LIKE tqa_file.tqa06,           #FUN-A60044
        tqa07       LIKE tqa_file.tqa07,           #FUN-A70063
        tqa02_n1    LIKE tqa_file.tqa02,           #FUN-A70063
        tqa08       LIKE tqa_file.tqa08,           #FUN-A70063
        tqa02_n2    LIKE tqa_file.tqa02,           #FUN-A70063
        tqa09       LIKE tqa_file.tqa09,           #FUN-B90056
        tqa02_n3    LIKE tqa_file.tqa02,           #FUN-B90056        
        tqaacti     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
        tqapos      LIKE tqa_file.tqapos           #No.FUN-A60066 VARCHAR(1) 
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,        #No.FUN-680120 VARCHAR(300)
    g_tit           LIKE zz_file.zz01,           #No.FUN-680120 VARCHAR(10)
    g_tit1          LIKE bxi_file.bxi01,           #No.FUN-680120 VARCHAR(16)
    g_rec_b         LIKE type_file.num5,           #單身筆數            #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5            #目前處理的ARRAY CNT #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING                         #SELECT ... FOR UPDATE   SQL
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5   #No.FUN-680120 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5           #No.FUN-680120 SMALLINT
    OPTIONS                                        #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理
 
    LET g_argv1      =ARG_VAL(1)                   #調用時傳遞的參數
    LET g_tqa03      =g_argv1
    LET g_tqa03_t    =g_tqa03
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    CASE 
       WHEN g_argv1='1'
            LET g_prog='atmi401'
       WHEN g_argv1='2'
            LET g_prog='atmi402'
       WHEN g_argv1='3'
            LET g_prog='atmi403'
       WHEN g_argv1='4'
            LET g_prog='atmi404'
       WHEN g_argv1='5'
            LET g_prog='atmi405'
       WHEN g_argv1='6'
            LET g_prog='atmi406'
       WHEN g_argv1='7'
            LET g_prog='atmi407'
       WHEN g_argv1='8'
            LET g_prog='atmi408'
       WHEN g_argv1='9'
            LET g_prog='atmi409'
       WHEN g_argv1='10'
            LET g_prog='atmi410'
       WHEN g_argv1='11'
            LET g_prog='atmi411'
       WHEN g_argv1='12'
            LET g_prog='atmi412'
       WHEN g_argv1='13'
            LET g_prog='atmi413'
       WHEN g_argv1='14'
            LET g_prog='atmi414'
       WHEN g_argv1='15'
            LET g_prog='atmi415'
       WHEN g_argv1='16'
            LET g_prog='atmi416'
       WHEN g_argv1='17'
            LET g_prog='atmi417'
       WHEN g_argv1='18'
            LET g_prog='atmi418'
       WHEN g_argv1='19'
            LET g_prog='atmi419'
       WHEN g_argv1='20'
            LET g_prog='atmi420'
       #FUN-870100---begin
       WHEN g_argv1='21'
            LET g_prog='arti101'
       WHEN g_argv1='22'
            LET g_prog='arti102'
       WHEN g_argv1='23'
            LET g_prog='arti103'
       WHEN g_argv1='24'
            LET g_prog='arti104'
       #FUN-870100---end
       #FUN-A40081---start
       WHEN g_argv1='25'
            LET g_prog='atmi421'
       WHEN g_argv1='26'
            LET g_prog='atmi422'
       #FUN-A40081---end
       WHEN g_argv1='27'                   #FUN-A60044
            LET g_prog='arti423'           #FUN-A60044
       WHEN g_argv1='28'                   #FUN-A70063
            LET g_prog='atmi428'           #FUN-A70063
       WHEN g_argv1='29'                   #FUN-B50006
            LET g_prog='atmi429'           #FUN-B50006
       WHEN g_argv1='30'                   #FUN-B80141
            LET g_prog='atmi430'           #FUN-B80141
       #FUN-B90056   Begin------
       WHEN g_argv1='31'
            LET g_prog='atmi431'
       WHEN g_argv1='32'
            LET g_prog='atmi432'
       WHEN g_argv1='33'
            LET g_prog='atmi433'  
       #FUN-B90056   End-------     
       OTHERWISE
            #CALL cl_err('','atm-002',1)   #FUN-870100
            CALL cl_err('','art-590',1)    #FUN-870100
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
            EXIT PROGRAM
   END CASE 
 
   LET g_tit = g_prog
 
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW i400_w AT p_row,p_col WITH FORM "atm/42f/atmi400"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_set_locale_frm_name("atmi400")
   CALL cl_ui_init()

   #FUN-A70063---begin
   IF g_argv1 = '2' THEN
      CALL cl_set_comp_visible('tqa07',TRUE)
      CALL cl_set_comp_visible('tqa02_n1',TRUE)
      CALL cl_set_comp_visible('tqa08',TRUE)
      CALL cl_set_comp_visible('tqa02_n2',TRUE)
      CALL cl_set_comp_visible('tqa09',TRUE)    #FUN-B90056 add    
      CALL cl_set_comp_visible('tqa02_n3',TRUE) #FUN-B90056 add         
   ELSE
      CALL cl_set_comp_visible('tqa07',FALSE)
      CALL cl_set_comp_visible('tqa02_n1',FALSE)
      CALL cl_set_comp_visible('tqa08',FALSE)
      CALL cl_set_comp_visible('tqa02_n2',FALSE)
      CALL cl_set_comp_visible('tqa09',FALSE)    #FUN-B90056 add    
      CALL cl_set_comp_visible('tqa02_n3',FALSE) #FUN-B90056 add    
   END IF
   #FUN-A70063---end
 
   #FUN-870100---begin
   IF g_argv1 = '14' THEN
      CALL cl_set_comp_visible('tqa04',TRUE)
   ELSE
      CALL cl_set_comp_visible('tqa04',FALSE)
   END IF
   #FUN-870100---end
 
   #FUN-A60044---begin
   IF g_argv1 = '27' THEN
      CALL cl_set_comp_visible('tqa05,tqa06',TRUE)
   ELSE
      CALL cl_set_comp_visible('tqa05,tqa06',FALSE)
   END IF
   #FUN-A60044---end

   #No.FUN-A60066..begin
   #IF (g_argv1 = '25' OR g_argv1 = '26') AND g_aza.aza88 = 'Y' THEN                   #FUN-B50006
   IF (g_argv1 = '25' OR g_argv1 = '26' OR g_argv1 = '29') AND g_aza.aza88 = 'Y' THEN  #FUN-B50006
      CALL cl_set_comp_visible('tqapos',TRUE)
   ELSE
      CALL cl_set_comp_visible('tqapos',FALSE)
   END IF
   #No.FUN-A60066..end
 
   DISPLAY g_tqa03 TO tqa03
   LET g_wc2 = " tqa03 ='",g_tqa03 CLIPPED,"' " 
   CALL i400_b_fill(g_wc2)
   CALL i400_menu()
 
   CLOSE WINDOW i400_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i400_menu()
 
   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i400_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
#TQC-640126 --begin
            LET g_msg = "atmr400 '",g_tqa03 CLIPPED,"' '' '' '' '' '' 'Y'"  #No.TQC-7B0031
            CALL cl_cmdrun(g_msg)
#           IF cl_chk_act_auth() THEN
#              CALL i400_out()
#           END IF
#TQC-640126 --end  
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_tqa03 IS NOT NULL THEN
                  LET g_doc.column1 = "tqa03"
                  LET g_doc.value1 = g_tqa03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqa),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i400_q()
   CALL i400_b_askkey()
END FUNCTION
 
FUNCTION i400_b()  #單身處理
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_n1            LIKE type_file.num5,                #檢查tqa07是否存在 #No.FUN-A70063 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_flag          LIKE type_file.chr1,                #NO.FUN-A70063
    l_tqa02_n1      LIKE tqa_file.tqa02                 #NO.FUN-A70063
DEFINE l_tqapos     LIKE tqa_file.tqapos                #FUN-B70075 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')                     #顯示操作方法
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    LET g_action_choice = ""
    LET g_forupd_sql = " SELECT tqa01,tqa02,tqa04,tqa05,tqa06,tqa07,'',tqa08,'',tqa09,'',tqaacti,tqapos FROM tqa_file ",   #FUN-A60044  #FUN-870100 No.FUN-A60066 NO.FUN-A70063 #FUN-B90056 add tqa09,''
                       " WHERE tqa03= ? AND tqa01= ? FOR UPDATE  "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    INPUT ARRAY g_tqa WITHOUT DEFAULTS FROM s_tqa.*
          ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                    INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd=''
        LET l_ac      = ARR_CURR()
        LET l_n       = ARR_COUNT()
        LET l_lock_sw = 'N'            #DEFAULT
        IF g_rec_b >= l_ac THEN
           #FUN-B70075 Begin---
           IF g_aza.aza88 = 'Y' AND (g_argv1 = '25' OR g_argv1 = '26' OR g_argv1 = '29') THEN
              UPDATE tqa_file SET tqapos = '4'
               WHERE tqa01 = g_tqa[l_ac].tqa01
                 AND tqa03 = g_tqa03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tqa_file",g_tqa_t.tqa01,"",SQLCA.sqlcode,"","",1)  
                 LET l_lock_sw = "Y"
              END IF
              LET l_tqapos = g_tqa[l_ac].tqapos
              LET g_tqa[l_ac].tqapos = '4'
              DISPLAY BY NAME g_tqa[l_ac].tqapos
           END IF
           #FUN-B70075 End-----          
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE                           
           CALL i400_set_entry(p_cmd)                               
           CALL i400_set_no_entry(p_cmd)                             
           LET g_before_input_done = TRUE                           
           LET g_tqa_t.* = g_tqa[l_ac].*  #BACKUP
           OPEN i400_bcl USING g_tqa03,g_tqa_t.tqa01
           IF STATUS THEN
              CALL cl_err("OPEN i400_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i400_bcl INTO g_tqa[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tqa_t.tqa01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              #NO.FUN-A70063---bengin
              SELECT tqa02 INTO g_tqa[l_ac].tqa02_n1 
                    FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa07 AND tqa03='2'
              SELECT tqa02 INTO g_tqa[l_ac].tqa02_n2 
                    FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa08 AND tqa03='28'
              #NO.FUN-A70063---bengin
              #FUN-B90056 Begin ----
              SELECT tqa02 INTO g_tqa[l_ac].tqa02_n3 
                FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa09 AND tqa03='32'
              #FUN-B90056 End ----  
           END IF
        END IF
     BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
        LET g_before_input_done = FALSE                           
        CALL i400_set_entry(p_cmd)                               
        CALL i400_set_no_entry(p_cmd)                             
        LET g_before_input_done = TRUE                           
        INITIALIZE g_tqa[l_ac].* TO NULL      #900423
        LET g_tqa[l_ac].tqaacti = 'Y'       #Body default
        #LET g_tqa[l_ac].tqapos = 'N'       #Body default  #No.FUN-A60066
        LET l_tqapos = '1'                  #FUN-B70075    
        LET g_tqa[l_ac].tqapos = '1'        #NO.FUN-B40071
        LET g_tqa_t.* = g_tqa[l_ac].*         #新輸入資料
        NEXT FIELD tqa01
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
        END IF
        IF cl_null(g_tqa[l_ac].tqa05) OR cl_null(g_tqa[l_ac].tqa06) THEN
           LET g_tqa[l_ac].tqa05=0
           LET g_tqa[l_ac].tqa06=0
        END IF
        INSERT INTO tqa_file(tqa01,tqa03,tqa02,tqa04,tqa05,tqa06,tqa07,tqa08,tqa09,tqaacti,tqapos,tqauser,tqadate,tqaoriu,tqaorig)  #FUN-A60044 #FUN-870100 #No.FUN-A60066 add pos #NO.FUN-A70063 add tqa07,tqa08 #FUN-B90056 add tqa09
                      VALUES(g_tqa[l_ac].tqa01,g_tqa03,g_tqa[l_ac].tqa02,g_tqa[l_ac].tqa04,  #FUN-870100
                             g_tqa[l_ac].tqa05,g_tqa[l_ac].tqa06,g_tqa[l_ac].tqa07,g_tqa[l_ac].tqa08,g_tqa[l_ac].tqa09,        #FUN-A60044 #NO.FUN-A70063 add tqa07,tqa08 #FUN-B90056 add tqa09
                             g_tqa[l_ac].tqaacti,g_tqa[l_ac].tqapos,g_user,g_today, g_user, g_grup) #No.FUN-980030 10/01/04  insert columns oriu, orig  #No.FUN-A60066 add pos
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_tqa[l_ac].tqa01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
           CALL cl_err3("ins","tqa_file",g_tqa[l_ac].tqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2  
        END IF
     AFTER FIELD tqa01                        #check 編號是否重復
        IF NOT cl_null(g_tqa[l_ac].tqa01) THEN
           IF g_tqa[l_ac].tqa01 != g_tqa_t.tqa01 
              OR g_tqa_t.tqa01 IS NULL THEN
               SELECT count(*) INTO l_n FROM tqa_file
                   WHERE tqa01 = g_tqa[l_ac].tqa01
                     AND tqa03 = g_tqa03
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_tqa[l_ac].tqa01 = g_tqa_t.tqa01
                  NEXT FIELD tqa01
               END IF
           END IF
           IF p_cmd ='a' THEN
           LET  g_tqa[l_ac].tqa07 =  g_tqa[l_ac].tqa01
           DISPLAY BY NAME g_tqa[l_ac].tqa07 
           END IF
        END IF

      #FUN-A70063---begin
      AFTER FIELD tqa02
         IF NOT cl_null(g_tqa[l_ac].tqa02) AND g_tqa[l_ac].tqa01 = g_tqa[l_ac].tqa07 AND p_cmd ='a' THEN
            LET g_tqa[l_ac].tqa02_n1 = g_tqa[l_ac].tqa02
            DISPLAY g_tqa[l_ac].tqa02_n1  TO tqa02_n1
         END IF 
            
      #FUN-A70063---end
      AFTER FIELD tqaacti
        IF NOT cl_null(g_tqa[l_ac].tqaacti) THEN
           IF g_tqa[l_ac].tqaacti NOT MATCHES '[YN]' THEN 
              LET g_tqa[l_ac].tqaacti = g_tqa_t.tqaacti
                  NEXT FIELD tqaacti
           END IF
        END IF
        
      #No.FUN-870100---begin
      AFTER FIELD tqa04
         IF NOT cl_null(g_tqa[l_ac].tqa04) THEN
            IF g_tqa[l_ac].tqa04<=0 THEN
               CALL cl_err('','atm-415',0)
               LET g_tqa[l_ac].tqa04 = g_tqa_t.tqa04
               NEXT FIELD tqa04
            END IF
         END IF
      #No.FUN-870100---end
 
      #No.FUN-A60044---begin
      AFTER FIELD tqa05
         IF NOT cl_null(g_tqa[l_ac].tqa05) THEN
            IF g_tqa[l_ac].tqa05<0 THEN
               CALL cl_err('','alm-450',0)
               LET g_tqa[l_ac].tqa05 = g_tqa_t.tqa05
               NEXT FIELD tqa05
            END IF
            IF NOT cl_null(g_tqa[l_ac].tqa06) THEN
               IF g_tqa[l_ac].tqa05>g_tqa[l_ac].tqa06 THEN
                  CALL cl_err('','art-651',0)
                  LET g_tqa[l_ac].tqa05 = g_tqa_t.tqa05
                  NEXT FIELD tqa05
               END IF
            END IF
         END IF
      #No.FUN-A60044---end
 
      #No.FUN-A60044---begin
      AFTER FIELD tqa06
         IF NOT cl_null(g_tqa[l_ac].tqa06) THEN
            IF g_tqa[l_ac].tqa06<0 THEN
               CALL cl_err('','alm-450',0)
               LET g_tqa[l_ac].tqa06 = g_tqa_t.tqa06
               NEXT FIELD tqa06
            END IF
            IF NOT cl_null(g_tqa[l_ac].tqa05) THEN
               IF g_tqa[l_ac].tqa05>g_tqa[l_ac].tqa06 THEN
                  CALL cl_err('','art-652',0)
                  LET g_tqa[l_ac].tqa06 = g_tqa_t.tqa06
                  NEXT FIELD tqa06
               END IF
            END IF
         END IF
      #No.FUN-A60044---end
     
      #NO.FUN-A70063---begin
      AFTER FIELD tqa07
         IF g_tqa[l_ac].tqa07 != g_tqa_t.tqa07 OR g_tqa[l_ac].tqa07 != g_tqa[l_ac].tqa01 THEN
         SELECT COUNT(*) INTO l_n1 FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa07 AND tqa03 = '2' 
            IF l_n1 = 0 THEN
               CALL cl_err(g_tqa[l_ac].tqa07,"alm-046",0)
               NEXT FIELD tqa07
            ELSE
              CALL i400_tqa07(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_tqa[l_ac].tqa07,g_errno,1)
                LET g_tqa[l_ac].tqa07 = g_tqa_t.tqa07
                NEXT FIELD tqa07
             END IF
           END IF
         END IF
        
        #FUN-A70063 -BEGIN----- Add By shi
         IF NOT cl_null(g_tqa[l_ac].tqa07) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_tqa[l_ac].tqa07 != g_tqa_t.tqa07) THEN
               LET l_flag = 'N'
               CALL i402_tqa07(g_tqa[l_ac].tqa01,g_tqa[l_ac].tqa07)
                  RETURNING l_flag
               IF l_flag = 'Y' THEN 
                  CALL cl_err(g_tqa[l_ac].tqa07,"atm-099",0)
                  LET g_tqa[l_ac].* =g_tqa_t.*
                  NEXT FIELD tqa07
               END IF
            END IF
         END IF
        #FUN-A70063 -END-------

      AFTER FIELD tqa08
        IF g_tqa[l_ac].tqa08 IS NOT NULL THEN 
           SELECT COUNT(*) INTO l_n1 FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa08 AND tqa03 = '28' 
           IF l_n1 = 0 THEN
              CALL cl_err(g_tqa[l_ac].tqa08,"alm1000",0)
              NEXT FIELD tqa08
           ELSE
              CALL i400_tqa08(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tqa[l_ac].tqa08,g_errno,1)
                 LET g_tqa[l_ac].tqa08 = g_tqa_t.tqa08
                 NEXT FIELD tqa08
              END IF
           END IF
        END IF
       #NO.FUN-A70063---end
#FUN-AA0071---------------add---------------str----------
          IF cl_null(g_tqa[l_ac].tqa08) THEN
             LET g_tqa[l_ac].tqa02_n2 = ''
          END IF
#FUN-AA0071---------------add---------------end----------

       #FUN-B90056 Begin ----
       AFTER FIELD tqa09
          IF NOT cl_null(g_tqa[l_ac].tqa09) THEN 
             CALL i400_tqa09('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_tqa[l_ac].tqa09,g_errno,1)
                LET g_tqa[l_ac].tqa09 = g_tqa_t.tqa09
                NEXT FIELD tqa09
             END IF
          ELSE
              LET g_tqa[l_ac].tqa02_n3 = ''   
          END IF 
       #FUN-B90056 End ---- 
       BEFORE DELETE                            #是否取消單身
         IF g_tqa_t.tqa01 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa07=g_tqa[l_ac].tqa01 AND tqa07 != tqa01
            IF l_n >= 1 THEN
               CALL cl_err(g_tqa[l_ac].tqa01,"alm1003",0)
               CANCEL DELETE
            ELSE

              #FUN-B50006 --begin 判斷已傳POS狀態
              IF (g_argv1 = '25' OR g_argv1 = '26' OR g_argv1 = '29') AND g_aza.aza88 = 'Y' THEN  
                #FUN-B70075 Begin---    
                #IF NOT (g_tqa[l_ac].tqapos='1' OR (g_tqa[l_ac].tqapos = '3' AND g_tqa[l_ac].tqaacti = 'N') ) THEN
                 IF NOT (l_tqapos ='1' OR (l_tqapos = '3' AND g_tqa_t.tqaacti = 'N')) THEN
                #FUN-B70075 End-----
                    CALL cl_err(g_tqa[l_ac].tqa01,"apc-139",0)
                    CANCEL DELETE
                 END IF
              END IF
              #FUN-B50006 --end

              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF
              #NO.FUN-A70063---begin
#             SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa07=g_tqa[l_ac].tqa01 AND tqa07 != tqa01
#             IF l_n >= 1 THEN
#                CALL cl_err(g_tqa[l_ac].tqa01,"alm1003",0)
#                CANCEL DELETE
#             ELSE
              #NO.FUN-A70063---end
              DELETE FROM tqa_file WHERE tqa01 = g_tqa_t.tqa01 AND tqa03 = g_tqa03_t #MOD-D10232 add tqa03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_tqa_t.tqa01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
                 CALL cl_err3("del","tqa_file",g_tqa_t.tqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
            END IF
        END IF
 
        
       ON ROW CHANGE
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_tqa[l_ac].* = g_tqa_t.*
           CLOSE i400_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        #No.FUN-A60066 ..begin
        #IF g_tqa[l_ac].tqa02<>g_tqa_t.tqa02 OR g_tqa[l_ac].tqa01<>g_tqa_t.tqa01 OR g_tqa[l_ac].tqa04<>g_tqa_t.tqa04 #FUN-B70075  mark
        #   OR g_tqa[l_ac].tqa05<>g_tqa_t.tqa05  OR g_tqa[l_ac].tqaacti<>g_tqa_t.tqaacti THEN #FUN-B70075  mark
          #FUN-B40071 --START--
           #LET g_tqa[l_ac].tqapos = 'N'
        #  IF g_tqa[l_ac].tqapos <> '1' THEN     #FUN-B70075 mark
        IF g_aza.aza88='Y' THEN
          #FUN-B70075 STA------
           IF g_argv1 = '25' OR g_argv1 = '26' OR g_argv1 = '29' THEN
              IF l_tqapos <> '1' THEN
                 LET g_tqa[l_ac].tqapos = '2'
              ELSE
                 LET g_tqa[l_ac].tqapos = '1'
              END IF
           END IF 
          #FUN-B70075 END------
          #FUN-B40071 --END--
           DISPLAY BY NAME g_tqa[l_ac].tqapos
        END IF  #FUN-B70075 
        #No.FUN-A60066 ..end
        IF l_lock_sw = 'Y' THEN
           CALL cl_err(g_tqa[l_ac].tqa01,-263,1)
           LET g_tqa[l_ac].* = g_tqa_t.*
        ELSE
           UPDATE tqa_file SET tqa01=g_tqa[l_ac].tqa01,
                               tqa03=g_tqa03,
                               tqa02=g_tqa[l_ac].tqa02,
                               tqa04=g_tqa[l_ac].tqa04,  #FUN-870100
                               tqa05=g_tqa[l_ac].tqa05,  #FUN-A60044
                               tqa06=g_tqa[l_ac].tqa06,  #FUN-A60044
                               tqa07=g_tqa[l_ac].tqa07,  #FUN-A70063
                               tqa08=g_tqa[l_ac].tqa08,  #FUN-A70063
                               tqa09=g_tqa[l_ac].tqa09,  #FUN-B90056
                               tqaacti=g_tqa[l_ac].tqaacti,
                               tqapos=g_tqa[l_ac].tqapos,#No.FUN-A60066
                               tqamodu=g_user,
                               tqadate=g_today
            WHERE tqa03 = g_tqa03
              AND tqa01 = g_tqa_t.tqa01 
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_tqa[l_ac].tqa01,SQLCA.sqlcode,0)  #No.FUN-660104  MARK
              CALL cl_err3("upd","tqa_file",g_tqa_t.tqa01,g_tqa03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
              LET g_tqa[l_ac].* = g_tqa_t.*
           ELSE
             #FUN-A70063 -BEGIN----- Mark By shi
             ##FUN.-A70063---begin
             #IF g_tqa[l_ac].tqa07 != g_tqa_t.tqa07 THEN 
             #      CALL i402_tqa07(g_tqa[l_ac].tqa01,g_tqa[l_ac].tqa07)
             #         RETURNING l_flag
             #      IF l_flag = 'Y' THEN
             #         CALL cl_err(g_tqa[l_ac].tqa07,"agl1000",0)
             #         LET g_tqa[l_ac].* =g_tqa_t.*
             #         CLOSE i400_bcl
             #         ROLLBACK WORK
             #         EXIT INPUT
             #     ELSE
             ##FUN.-A70063---end
             #FUN-A70063 -END-------
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
             #     END IF   #FUN-A70063 Mark By shi
             #   END IF     #FUN-A70063 Mark By shi
           END IF
        END IF
     AFTER ROW
        LET l_ac = ARR_CURR()
       #LET l_ac_t = l_ac   #FUN-D30033 mark
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tqa[l_ac].* = g_tqa_t.*
           #FUN-D30033--add--begin--
           ELSE
              CALL g_tqa.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30033--add--end----
           END IF
           CLOSE i400_bcl
           ROLLBACK WORK
           #FUN-B70075 Begin---
           IF p_cmd='u' THEN
              IF g_aza.aza88 = 'Y' AND (g_argv1 = '25' OR g_argv1 = '26' OR g_argv1 = '29') THEN
                 UPDATE tqa_file SET tqapos = l_tqapos
                  WHERE tqa01 = g_tqa_t.tqa01
                    AND tqa03 = g_tqa03_t
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","tqa_file",g_tqa_t.tqa01,"",SQLCA.sqlcode,"","",1)
                    LET l_lock_sw = "Y"
                 END IF
                 LET g_tqa[l_ac].tqapos = l_tqapos
                 DISPLAY BY NAME g_tqa[l_ac].tqapos
              END IF
           END IF
           #FUN-B70075 End-----            
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac    #FUN-D30033 add
        CLOSE i400_bcl
        COMMIT WORK

     ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tqa01) AND l_ac > 1 THEN
            LET g_tqa[l_ac].* = g_tqa[l_ac-1].*
            NEXT FIELD tqa01
        END IF
     #NO.FUN-A70063---begin
     ON ACTION controlp 
        IF INFIELD(tqa07) THEN                                                  
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form="q_tqa07_1"                                       
            LET g_qryparam.default1=g_tqa[l_ac].tqa07                                 
            CALL cl_create_qry() RETURNING g_tqa[l_ac].tqa07                 
            DISPLAY BY NAME g_tqa[l_ac].tqa07                                
            NEXT FIELD tqa07 
        END IF
        IF INFIELD(tqa08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_tqa08"
            LET g_qryparam.default1=g_tqa[l_ac].tqa08
            CALL cl_create_qry() RETURNING g_tqa[l_ac].tqa08
            DISPLAY BY NAME g_tqa[l_ac].tqa08
            NEXT FIELD tqa08
        END IF
     #NO.FUN-A70063---end
     #FUN-B90056 Begin ----
        IF INFIELD(tqa09) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form="q_tqa"
            LET g_qryparam.arg1 = '32'
            LET g_qryparam.default1=g_tqa[l_ac].tqa09
            CALL cl_create_qry() RETURNING g_tqa[l_ac].tqa09
            DISPLAY BY NAME g_tqa[l_ac].tqa09
            NEXT FIELD tqa09
        END IF
     #FUN-B90056 End ----   
     ON ACTION CONTROLR
       CALL cl_show_req_fields()
     ON ACTION CONTROLG
        CALL cl_cmdask()
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
    
   END INPUT
 
   CLOSE i400_bcl
   COMMIT WORK
 
END FUNCTION

#NO.FUN-A700063---begin
#FUNCTION i402_tqa07(p_tqa01,p_tqa07)
#  DEFINE p_tqa01 LIKE tqa_file.tqa01
#  DEFINE p_tqa07 LIKE tqa_file.tqa07
#  DEFINE l_cnt   LIKE type_file.num5
#  DEFINE l_i     LIKE type_file.num5
#  DEFINE l_flag  LIKE type_file.chr1
#  DEFINE l_n2    LIKE type_file.num5 
#  DEFINE l_tqa01 DYNAMIC ARRAY OF VARCHAR 
#  LET l_flag ='N'
#  DECLARE i400_auth CURSOR FOR 
#     SELECT tqa01 FROM tqa_file WHERE tqa07=p_tqa01 AND tqaacti='Y' AND tqa03='2' AND tqa01 != p_tqa01 
#  LET l_cnt = 1
#  FOREACH i400_auth INTO l_tqa01[l_cnt]
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF

#     IF l_tqa01[l_cnt] = p_tqa07 AND p_tqa07 != p_tqa01 THEN 
#        LET l_flag = 'Y'
#        RETURN l_flag
#        EXIT FOREACH 
#     END IF
#     LET l_cnt = l_cnt + 1
#     IF l_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#  END FOREACH
#   IF l_flag = 'N' AND l_cnt-1 >0 THEN

#   FOR l_i = 1 TO l_cnt-1
#      SELECT COUNT(*) INTO l_n2 FROM tqa_file WHERE tqa07 = l_tqa01[l_i] AND tqa01 !=l_tqa01[l_i]
#      IF l_n2 != 0 THEN

#         CALL i402_tqa07(l_tqa01[l_i],p_tqa07) RETURNING l_flag
#      END IF
#    END FOR
#  END IF
#   RETURN l_flag
#END FUNCTION
#NO.FUN-A70063---end

 FUNCTION i402_tqa07(p_tqa01,p_tqa07)
   DEFINE p_tqa01 LIKE tqa_file.tqa01
   DEFINE p_tqa07 LIKE tqa_file.tqa07
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_n2    LIKE type_file.num5
   DEFINE l_tqa07 DYNAMIC ARRAY OF VARCHAR(10) 
   LET l_flag ='N'
   DECLARE i400_auth CURSOR FOR
      SELECT tqa07 FROM tqa_file WHERE tqa01=p_tqa07 AND tqaacti='Y' AND tqa03='2' #AND tqa07 != p_tqa01  
   LET l_cnt = 1
   FOREACH i400_auth INTO l_tqa07[l_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF l_tqa07[l_cnt] = p_tqa01 AND p_tqa01 != p_tqa07 THEN
         LET l_flag = 'Y'
         LET l_cnt = 0
         RETURN l_flag
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
      IF l_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
    IF l_flag = 'N' AND l_cnt-1 >0 THEN

    FOR l_i = 1 TO l_cnt-1
       SELECT COUNT(*) INTO l_n2 FROM tqa_file WHERE tqa01 = l_tqa07[l_i] AND tqa07 != l_tqa07[l_i] 
       IF l_n2 != 0 THEN
          CALL i402_tqa07(p_tqa01,l_tqa07[l_i]) RETURNING l_flag
       END IF
     END FOR
   END IF
    RETURN l_flag
 END FUNCTION

#NO.FUN-A70063---begin
FUNCTION i400_tqa07(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno=''

   SELECT tqa02,tqaacti INTO g_tqa[l_ac].tqa02_n1,l_tqaacti FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa07 AND tqa03='2'
   CASE
      WHEN SQLCA.sqlcode =100 LET g_errno='alm-009'
                              LET g_tqa[l_ac].tqa02_n1 = NULL
      WHEN l_tqaacti='N'      LET g_errno='9028'
                              LET g_tqa[l_ac].tqa02_n1=g_tqa_t.tqa02_n1
   OTHERWISE
      LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

    IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY BY NAME g_tqa[l_ac].tqa02_n1
    END IF

END FUNCTION

FUNCTION i400_tqa08(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno=''

   SELECT tqa02,tqaacti INTO g_tqa[l_ac].tqa02_n2,l_tqaacti FROM tqa_file WHERE tqa01=g_tqa[l_ac].tqa08 
                                                                            AND tqa03='28'
   CASE
      WHEN SQLCA.sqlcode =100 LET g_errno='alm-009'
                              LET g_tqa[l_ac].tqa02_n2 = NULL
      WHEN l_tqaacti='N'      LET g_errno='9028' 
                              LET g_tqa[l_ac].tqa02_n2=g_tqa_t.tqa02_n2
   OTHERWISE
      LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
    IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY BY NAME g_tqa[l_ac].tqa02_n2
    END IF 
END FUNCTION
#NO.FUN-A70063---end 
#FUN-B90056  Begin ----
FUNCTION i400_tqa09(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno=''

   SELECT tqa02,tqaacti INTO g_tqa[l_ac].tqa02_n3,l_tqaacti 
     FROM tqa_file
    WHERE tqa01=g_tqa[l_ac].tqa09 
      AND tqa03='32'
   CASE
      WHEN SQLCA.sqlcode =100 LET g_errno='alm-009'
                              LET g_tqa[l_ac].tqa02_n3 = NULL
      WHEN l_tqaacti='N'      LET g_errno='9028' 
                              LET g_tqa[l_ac].tqa02_n3=g_tqa_t.tqa02_n3
   OTHERWISE
      LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
    IF p_cmd='d' OR cl_null(g_errno)THEN
       DISPLAY BY NAME g_tqa[l_ac].tqa02_n3
    END IF 
END FUNCTION
#FUN-B90056 End ----
FUNCTION i400_b_askkey()
    CLEAR FORM
    CALL g_tqa.clear()
    DISPLAY g_tqa03 TO tqa03
 
    CONSTRUCT g_wc2 ON tqa01,tqa02,tqa04,tqa05,tqa06,tqa07,tqa08,tqa09,tqaacti,tqapose    #FUN-A60044  #FUN-510041 add azf05  #FUN-870100  #FUN-A70063 add tqa07,tqa08 #FUN-B90056 add tqa09  #FUN-B70075 ADD tqapos
         FROM s_tqa[1].tqa01,s_tqa[1].tqa02,s_tqa[1].tqa04,
              s_tqa[1].tqa05,s_tqa[1].tqa06,s_tqa[1].tqa07,s_tqa[1].tqa08,s_tqa[1].tqa09,   #FUN-A60044  #FUN-A70063 #FUN-B90056 add tqa09 
              s_tqa[1].tqaacti,s_tqa[1].tqapos                               #FUN-B70075 ADD tqapos
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
         
         #NO.FUN-A70063---begin
         ON ACTION controlp
         IF INFIELD(tqa07) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form="q_tqa07"
            LET g_qryparam.default1 = g_tqa[l_ac].tqa07
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO tqa07 
            NEXT FIELD tqa07
        END IF
        IF INFIELD(tqa08) THEN
             CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form="q_tqa08_1"
            LET g_qryparam.default1 = g_tqa[l_ac].tqa08
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO tqa08 
            NEXT FIELD tqa08
        END IF
     #NO.FUN-A70063---end
     #FUN-B90056 Begin ----
        IF INFIELD(tqa09) THEN
             CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form="q_tqa09_1"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO tqa09 
            NEXT FIELD tqa09
        END IF
     #FUN-B90056 End ----
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about        
            CALL cl_about()      
        
         ON ACTION help         
            CALL cl_show_help()
        
         ON ACTION controlg   
            CALL cl_cmdask() 
     
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
             CALL cl_qbe_select() 
         ON ACTION qbe_save
             CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('tqauser', 'tqagrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET g_wc2 =g_wc2 CLIPPED, "  AND tqa03 ='",g_tqa03 CLIPPED,"' " 
    CALL i400_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i400_b_fill(p_wc2)              #抓取單身數據
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT tqa01,tqa02,tqa04,tqa05,tqa06,tqa07,'',tqa08,'',tqa09,'',tqaacti,tqapos  FROM tqa_file ", #FUN-A60044  #FUN-870100 #No.FUN-A60066 #FUN-A70063 #FUN-B90056 add tqa09,''
        " WHERE ", p_wc2 CLIPPED,                  
        " ORDER BY tqa01"
   DECLARE tqa_curs CURSOR FROM g_sql
		
    CALL g_tqa.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tqa_curs INTO g_tqa[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
        #NO.FUN-A70063---begin
        IF g_tqa[g_cnt].tqa07 IS NULL THEN 
           LET g_tqa[g_cnt].tqa07 = g_tqa[g_cnt].tqa01
           UPDATE tqa_file SET tqa07 = g_tqa[g_cnt].tqa07
             WHERE tqa01 = g_tqa[g_cnt].tqa01  AND tqa07 IS NULL
           DISPLAY  g_tqa[g_cnt].tqa07 TO tqa07
       END IF
 
       SELECT tqa02 INTO g_tqa[g_cnt].tqa02_n1 FROM tqa_file WHERE tqa01=g_tqa[g_cnt].tqa07 AND tqa03='2'   
       SELECT tqa02 INTO g_tqa[g_cnt].tqa02_n2 FROM tqa_file WHERE tqa01=g_tqa[g_cnt].tqa08 AND tqa03='28'  
       DISPLAY g_tqa[g_cnt].tqa02_n1,g_tqa[g_cnt].tqa02_n2  TO tqa02_n1,tqa02_n2
      
       #NO.FUN-A70063---end
       #FUN-B90056 Begin ----
       IF NOT cl_null(g_tqa[g_cnt].tqa09) THEN 
          SELECT tqa02 INTO g_tqa[g_cnt].tqa02_n3 FROM tqa_file WHERE tqa01=g_tqa[g_cnt].tqa09 AND tqa03='32'  
          DISPLAY g_tqa[g_cnt].tqa02_n3  TO tqa02_n3
       END IF
       #FUN-B90056 End ----
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
       END IF
      
    END FOREACH
    CALL g_tqa.deleteElement(g_cnt)   #刪除最后一行的空行
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1   #得到單身筆數
 
    DISPLAY g_rec_b TO FORMONLY.cn2  #將筆數顯示在畫面上的“cn2”欄位
    LET g_cnt = 0   #可不寫
 
END FUNCTION
 
 
FUNCTION i400_bp(p_ud)			#依照所選action，呼叫所屬功能的function
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqa TO s_tqa.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
 
   
#@    ON ACTION 相關文件  
      ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#TQC-640126 --begin
#{
#FUNCTION i400_out()
#    DEFINE
#        l_tqa           RECORD LIKE tqa_file.*,
#        l_n,l_waitsec   LIKE type_file.num5,          #No.FUN-680120 SMALLINT
#        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
#        l_prog          LIKE zz_file.zz01,            #No.FUN-680120 VARCHAR(20)                
#        l_buf           LIKE aab_file.aab02,          #No.FUN-680120 VARCHAR(6)
#        l_sw            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#        l_cmd           STRING
# 
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#       RETURN 
#    END IF
# 
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
# 
#    LET g_sql="SELECT * FROM tqa_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i400_p1 FROM g_sql                    # RUNTIME 編譯
#    DECLARE i400_co                               # SCROLL CURSOR
#         CURSOR FOR i400_p1
# 
#    LET g_rlang = g_lang                          #FUN-4C0096 add
#    LET l_prog  = g_prog
#    LET g_prog='atmi400'
#    CALL cl_outnam('atmi400') RETURNING l_name
#    SELECT zz06 INTO l_sw
#     FROM zz_FILE WHERE zz01 = g_tit 
# 
#    IF l_sw = '1' THEN   
#        LET l_name = g_tit CLIPPED,'.out'
#    ELSE
#        SELECT zz16,zz24  INTO l_n,l_waitsec
#            FROM zz_FILE WHERE zz01 = g_tit
#        IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
#        LET l_n = l_n + 1
#        IF l_n > 30000 THEN  LET l_n = 0  END IF
#        UPDATE zz_file SET zz16 = l_n WHERE zz01 = g_tit 
#        LET l_buf = l_n USING "&&&&&&"
#        LET l_name = g_tit CLIPPED,".",l_buf[5,6],"r"
#   END IF
# 
#    LET g_xml_rep = l_name CLIPPED,".xml"
#    LET l_cmd = 'rm -f ',l_name CLIPPED,'*'
#    RUN l_cmd
#    CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
# 
#    START REPORT i400_rep TO l_name
# 
#    FOREACH i400_co INTO l_tqa.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#          END IF
#       OUTPUT TO REPORT i400_rep(l_tqa.*)
#    END FOREACH
# 
#    FINISH REPORT i400_rep
# 
#    CLOSE i400_co
#    ERROR ""
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
# 
#END FUNCTION
# 
#REPORT i400_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#        l_str           LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(40)
#        sr RECORD LIKE tqa_file.*
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#   ORDER BY sr.tqa01
# 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           CASE
#               WHEN g_argv1='1'
#                    LET g_x[1]=g_x[10],'-',g_x[30] 
#               WHEN g_argv1='2'
#                    LET g_x[1]=g_x[11],'-',g_x[30] 
#               WHEN g_argv1='3'
#                    LET g_x[1]=g_x[12],'-',g_x[30] 
#               WHEN g_argv1='4'    
#                    LET g_x[1]=g_x[13],'-',g_x[30]   
#               WHEN g_argv1='5'
#                    LET g_x[1]=g_x[14],'-',g_x[30]  
#               WHEN g_argv1='6'
#                    LET g_x[1]=g_x[15],'-',g_x[30]  
#               WHEN g_argv1='7'
#                    LET g_x[1]=g_x[16],'-',g_x[30]  
#               WHEN g_argv1='8'
#                    LET g_x[1]=g_x[17],'-',g_x[30]  
#               WHEN g_argv1='9'
#                    LET g_x[1]=g_x[18],'-',g_x[30]  
#               WHEN g_argv1='10'
#                    LET g_x[1]=g_x[19],'-',g_x[30]  
#               WHEN g_argv1='11'
#                    LET g_x[1]=g_x[20],'-',g_x[30] 
#               WHEN g_argv1='12'
#                    LET g_x[1]=g_x[21],'-',g_x[30] 
#               WHEN g_argv1='13'
#                    LET g_x[1]=g_x[22],'-',g_x[30] 
#               WHEN g_argv1='13'
#                    LET g_x[1]=g_x[22],'-',g_x[30] 
#               WHEN g_argv1='14'
#                    LET g_x[1]=g_x[23],'-',g_x[30] 
#               WHEN g_argv1='15'
#                    LET g_x[1]=g_x[24],'-',g_x[30] 
#               WHEN g_argv1='16'
#                    LET g_x[1]=g_x[25],'-',g_x[30] 
#               WHEN g_argv1='17'
#                    LET g_x[1]=g_x[26],'-',g_x[30] 
#               WHEN g_argv1='18'
#                    LET g_x[1]=g_x[27],'-',g_x[30] 
#               WHEN g_argv1='19'
#                    LET g_x[1]=g_x[28],'-',g_x[30] 
#               WHEN g_argv1='20'
#                    LET g_x[1]=g_x[29],'-',g_x[30] 
#           END CASE 
# 
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[35],
#                 g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
# 
#       ON EVERY ROW
#           IF sr.tqaacti = 'N'  THEN     
#              LET l_str = '*'
#           ELSE 
#              LET l_str = ' '
#           END IF
#           PRINT COLUMN g_c[35],l_str CLIPPED,
#                 COLUMN g_c[31],sr.tqa01 CLIPPED,
#                 COLUMN g_c[32],sr.tqa03,  
#                 COLUMN g_c[33],sr.tqa02,
#                 COLUMN g_c[34],sr.tqaacti
#           PRINT ''
# 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#              PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
# 
#END REPORT
#}
#TQC-640126 --end  
FUNCTION i400_set_entry(p_cmd)                                          
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                  
     CALL cl_set_comp_entry("tqa01",TRUE)                              
   END IF                                                               
END FUNCTION                                                                                                                                                                        
 
FUNCTION i400_set_no_entry(p_cmd)                                      
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN   
     CALL cl_set_comp_entry("tqa01",FALSE)                            
   END IF                                                  
END FUNCTION         
#MOD-C60207 add
                                                    
