# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern Name...: atmi217.4gl
# Descriptions...: 銷售原因碼維護作業(atmi217) 
# Date & Author..: 05/12/01 By Tracy
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-670008 06/07/12 By Tracy 用途選銷退時,令搭贈可entry
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-730033 07/03/29 By Carrier 會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_tqe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tqe01       LIKE tqe_file.tqe01,  
        tqe02       LIKE tqe_file.tqe02,   
        tqe03       LIKE tqe_file.tqe03,
        tqe04       LIKE tqe_file.tqe04,
        tqe05       LIKE tqe_file.tqe05,
        tqe11       LIKE tqe_file.tqe11,
        tqe12       LIKE tqe_file.tqe12,
        tqe06       LIKE tqe_file.tqe06,
        aag02       LIKE aag_file.aag02,
        tqe09       LIKE tqe_file.tqe09,
        tqe07       LIKE tqe_file.tqe07,
        aag02a      LIKE aag_file.aag02,
        tqe10       LIKE tqe_file.tqe10,
        tqe08       LIKE tqe_file.tqe08,
        tqeacti     LIKE tqe_file.tqeacti   
                    END RECORD,
    g_tqe_t         RECORD                     #程式變數 (舊值)
        tqe01       LIKE tqe_file.tqe01,  
        tqe02       LIKE tqe_file.tqe02,   
        tqe03       LIKE tqe_file.tqe03,
        tqe04       LIKE tqe_file.tqe04,
        tqe05       LIKE tqe_file.tqe05,
        tqe11       LIKE tqe_file.tqe11,
        tqe12       LIKE tqe_file.tqe12, 
        tqe06       LIKE tqe_file.tqe06,
        aag02       LIKE aag_file.aag02,
        tqe09       LIKE tqe_file.tqe09,
        tqe07       LIKE tqe_file.tqe07,
        aag02a      LIKE aag_file.aag02,
        tqe10       LIKE tqe_file.tqe10,
        tqe08       LIKE tqe_file.tqe08,
        tqeacti     LIKE tqe_file.tqeacti 
                    END RECORD,
    g_wc,g_sql      STRING,
    g_rec_b         LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING                        #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE g_i          LIKE type_file.num5           #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000        #No.FUN-680120
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680120 SMALLINT
 
MAIN
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    OPEN WINDOW i217_w WITH FORM "atm/42f/atmi217"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    CALL cl_set_comp_visible("tqe12,tqe06,aag02,tqe09,tqe07,aag02a,tqe10",FALSE)  
    LET   g_wc = '1=1' 
    CALL  i217_b_fill(g_wc)
    CALL  i217_menu()
    CLOSE WINDOW i217_w                        #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i217_q()
    CALL i217_b_askkey()
END FUNCTION
 
FUNCTION i217_b_askkey()
 
    CLEAR FORM
    CALL g_tqe.clear()
 
    CONSTRUCT g_wc ON tqe01,tqe02,tqe03,tqe04,tqe05,tqe11,tqe12,  
                      tqe06,tqe09,tqe07,tqe10,tqe08,tqeacti 
         FROM s_tqe[1].tqe01,s_tqe[1].tqe02,s_tqe[1].tqe03,
              s_tqe[1].tqe04,s_tqe[1].tqe05,s_tqe[1].tqe11,s_tqe[1].tqe12,
              s_tqe[1].tqe06,s_tqe[1].tqe09,s_tqe[1].tqe07,
              s_tqe[1].tqe10,s_tqe[1].tqe08,s_tqe[1].tqeacti
              
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
    CONTINUE CONSTRUCT
 
    ON ACTION CONTROLP                                                      
       CASE                                                                  
       WHEN INFIELD(tqe06) 
            CALL cl_init_qry_var()                                       
            LET g_qryparam.form  ="q_aag07"                                 
            LET g_qryparam.state ="c"                                   
#           LET g_qryparam.where =" aag07 != '1' AND aag03 ='2' 
#               AND aag00= '",g_aaz.aaz64,"'"
            CALL cl_create_qry() 
            RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tqe06 
            NEXT FIELD tqe06                                         
                                                                                
       WHEN INFIELD(tqe07) 
            CALL cl_init_qry_var()                                       
            LET g_qryparam.form ="q_aag07"                                 
            LET g_qryparam.state = "c"                                   
#           LET g_qryparam.where =" aag07 != '1' AND aag03 ='2' 
#               AND aag00= '",g_aaz.aaz66,"'"   
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tqe07 
            NEXT FIELD tqe07                                         
       END CASE
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqeuser', 'tqegrup') #FUN-980030
 
    IF INT_FLAG THEN  RETURN END IF
    CALL i217_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i217_menu()
 
    WHILE TRUE
       CALL i217_bp("G")
       CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i217_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i217_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqe),'','')                                                     
            END IF                 
       END CASE
    END WHILE
 
END FUNCTION
 
#單身
FUNCTION i217_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                     #未取消的ARRAY CNT#No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                     #檢查重復用       #No.FUN-680120 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                      #單身鎖住否      #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                      #處理狀態        #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.dat,              #No.FUN-680120 DATE                  #可新增否
   l_allow_delete  LIKE type_file.dat               #No.FUN-680120 DATE                  #可刪除否
 
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
   DISPLAY g_msg CLIPPED AT 2,38               #該操作方法為^U
 
   LET g_forupd_sql = "SELECT tqe01,tqe02,tqe03,",
                      "       tqe04,tqe05,tqe11,tqe12, ", 
                      "       tqe06,'',tqe09, ",
                      "       tqe07,'',tqe10,tqe08,tqeacti ",
                      "  FROM tqe_file",
                      "  WHERE tqe01 =? ",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i217_bcl CURSOR FROM g_forupd_sql   # LOCK CURSOR
 
 
   INPUT ARRAY g_tqe WITHOUT DEFAULTS FROM s_tqe.* 
   ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                 #DEFAULT
 
           IF g_rec_b>=l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_tqe_t.* = g_tqe[l_ac].*    #BACKUP
              OPEN i217_bcl USING g_tqe_t.tqe01
              IF STATUS THEN
                 CALL cl_err("OPEN i217_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE 
                 FETCH i217_bcl INTO g_tqe[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqe_t.tqe01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT aag02 INTO  g_tqe[l_ac].aag02
                   FROM aag_file
                  WHERE aag01=g_tqe[l_ac].tqe06      
                    AND aag00=g_aza.aza81  #No.FUN-730033
                 SELECT aag02 INTO  g_tqe[l_ac].aag02a
                   FROM aag_file
                  WHERE aag01=g_tqe[l_ac].tqe07    
                    AND aag00=g_aza.aza82  #No.FUN-730033
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tqe[l_ac].* TO NULL      
           LET g_tqe_t.* = g_tqe[l_ac].*     
           LET g_tqe[l_ac].tqe03  = '1'
           LET g_tqe[l_ac].tqe04  = 'N'
           LET g_tqe[l_ac].tqe05  = 'N'
           LET g_tqe[l_ac].tqe08  = 'N'
           LET g_tqe[l_ac].tqe11  = 'N'
           LET g_tqe[l_ac].tqeacti= 'Y'
           NEXT FIELD tqe01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i217_bcl
              CANCEL INSERT
           END IF
 
           INSERT INTO tqe_file(tqe01,tqe02,tqe03,tqe04,tqe05,tqe11,tqe12,
                                tqe06,tqe09,tqe07,tqe10,tqe08,tqeacti,tqeoriu,tqeorig)
           VALUES(g_tqe[l_ac].tqe01,g_tqe[l_ac].tqe02,g_tqe[l_ac].tqe03,
                  g_tqe[l_ac].tqe04,g_tqe[l_ac].tqe05,g_tqe[l_ac].tqe11,
                  g_tqe[l_ac].tqe12,g_tqe[l_ac].tqe06,g_tqe[l_ac].tqe09,
                  g_tqe[l_ac].tqe07,g_tqe[l_ac].tqe10,g_tqe[l_ac].tqe08,   
                  g_tqe[l_ac].tqeacti, g_user, g_grup)           #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tqe[l_ac].tqe01,SQLCA.sqlcode,0) #No.FUN-660104
              CALL cl_err3("ins","tqe_file",g_tqe[l_ac].tqe01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b = g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD tqe01                      #check 序號是否重復
           IF NOT cl_null(g_tqe[l_ac].tqe01) THEN 
              IF g_tqe_t.tqe01 != g_tqe[l_ac].tqe01
                 OR g_tqe_t.tqe01 IS NULL THEN 
                 SELECT count(*) INTO l_n FROM tqe_file
                  WHERE tqe01 = g_tqe[l_ac].tqe01
                 IF l_n > 0  THEN 
                    CALL cl_err('','-239',0)  #重復
                    NEXT FIELD tqe01
                 END IF
              END IF 
           END IF 
        BEFORE FIELD tqe03
           CALL cl_set_comp_entry("tqe04",TRUE)  
           CALL cl_set_comp_entry("tqe05",TRUE) 
           CALL cl_set_comp_entry("tqe08",TRUE) 
             
        AFTER FIELD tqe03         
           IF cl_null(g_tqe[l_ac].tqe03) OR
              g_tqe[l_ac].tqe03 not MATCHES '[123456]' THEN
              NEXT FIELD tqe03 
           END IF
           CALL i217_set_entry_tqe03(g_tqe[l_ac].tqe03)   
           CALL i217_set_no_entry_tqe03(g_tqe[l_ac].tqe03)  
#          IF g_tqe[l_ac].tqe03<>'1' THEN                #No.FUN-670008 mark
           IF g_tqe[l_ac].tqe03 NOT MATCHES '[12]' THEN  #No.FUN-670008
              LET g_tqe[l_ac].tqe04='N'
              CALL cl_set_comp_entry("tqe04",FALSE)  
           END IF
           IF g_tqe[l_ac].tqe03='3' THEN
              LET g_tqe[l_ac].tqe05='N'
              CALL cl_set_comp_entry("tqe05",FALSE)  
           END IF
           IF g_tqe[l_ac].tqe03<>'2' THEN
              LET g_tqe[l_ac].tqe08='N'
              CALL cl_set_comp_entry("tqe08",FALSE)  
           END IF
 
        AFTER FIELD tqe06
           IF cl_null(g_tqe[l_ac].tqe06) THEN
	      NEXT FIELD tqe06
           ELSE
              SELECT count(*) INTO l_n FROM aag_file
               WHERE aag01=g_tqe[l_ac].tqe06 AND aag07 != '1' 
                 AND aag03 ='2' 
                 AND aag00=g_aza.aza81  #No.FUN-730033
#                AND aag00= g_aaz.aaz64               
              IF l_n=0 THEN
                 CALL cl_err(g_tqe[l_ac].tqe06,'aap-262',0) 
#FUN-B10052 --begin--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag07"
                  LET g_qryparam.construct ="N"
                  LET g_qryparam.where =" aag01 LIKE '",g_tqe[l_ac].tqe06 CLIPPED,"%'" 
                  LET g_qryparam.arg1 = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_tqe[l_ac].tqe06
                  DISPLAY BY NAME g_tqe[l_ac].tqe06
#FUN-B10052 --end--
	         NEXT FIELD tqe06
              END IF
              SELECT aag02 INTO  g_tqe[l_ac].aag02
                FROM aag_file
               WHERE aag01=g_tqe[l_ac].tqe06      
                 AND aag00=g_aza.aza81  #No.FUN-730033
           END IF

        AFTER FIELD tqe07                                                   
           IF NOT cl_null(g_tqe[l_ac].tqe07) THEN
              SELECT count(*) INTO l_n FROM aag_file                           
               WHERE aag01=g_tqe[l_ac].tqe07 AND aag07 != '1'           
                 AND aag03 ='2' 
                 AND aag00=g_aza.aza82  #No.FUN-730033
              IF l_n=0 THEN                                                    
                 CALL cl_err(g_tqe[l_ac].tqe07,'aap-262',0)  
#FUN-B10052 --begin--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag07"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where =" aag01 LIKE '",g_tqe[l_ac].tqe07 CLIPPED,"%'" 
                  LET g_qryparam.arg1 = g_aza.aza82  
                  CALL cl_create_qry() RETURNING g_tqe[l_ac].tqe07
                  DISPLAY BY NAME g_tqe[l_ac].tqe07
#FUN-B10052 --end--
                 NEXT FIELD tqe07                                          
              END IF
              SELECT aag02 INTO  g_tqe[l_ac].aag02a
                FROM aag_file
               WHERE aag01=g_tqe[l_ac].tqe07  
                 AND aag00=g_aza.aza82  #No.FUN-730033
           END IF
            
        BEFORE DELETE              
           IF g_tqe_t.tqe01 IS NOT NULL THEN  
              IF NOT cl_delete() THEN  
                 CANCEL DELETE       
              END IF                                                            
              IF l_lock_sw = "Y" THEN                                           
                 CALL cl_err("", -263, 1)                                       
                 CANCEL DELETE                                                  
              END IF                                                            
              DELETE FROM tqe_file                                           
               WHERE tqe01 = g_tqe_t.tqe01                             
              IF SQLCA.sqlcode THEN                                             
              #  CALL cl_err(g_tqe_t.tqe01,SQLCA.sqlcode,0)                 #No.FUN-660104
                 CALL cl_err3("del","tqe_file",g_tqe_t.tqe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK                                                  
                 CANCEL DELETE                                                  
              END IF  
              COMMIT WORK      
              LET g_rec_b=g_rec_b-1                                             
              DISPLAY g_rec_b TO FORMONLY.cn2                                   
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqe[l_ac].* = g_tqe_t.*
              CLOSE i217_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_tqe[l_ac].tqe01,-263,0)
              LET g_tqe[l_ac].* = g_tqe_t.*
           ELSE
              UPDATE tqe_file SET tqe01=g_tqe[l_ac].tqe01,
                                  tqe02=g_tqe[l_ac].tqe02,
				  tqe03=g_tqe[l_ac].tqe03,
				  tqe04=g_tqe[l_ac].tqe04,
                                  tqe05=g_tqe[l_ac].tqe05,
                                  tqe11=g_tqe[l_ac].tqe11,
                                  tqe12=g_tqe[l_ac].tqe12,  
                                  tqe06=g_tqe[l_ac].tqe06,
                                  tqe09=g_tqe[l_ac].tqe09,
                                  tqe07=g_tqe[l_ac].tqe07,
                                  tqe10=g_tqe[l_ac].tqe10,
                                  tqe08=g_tqe[l_ac].tqe08,
                                  tqeacti=g_tqe[l_ac].tqeacti
               WHERE tqe01 = g_tqe_t.tqe01
               
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
	       ELSE
               #  CALL cl_err(g_tqe[l_ac].tqe01,SQLCA.sqlcode,0)   #No.FUN-660104
                  CALL cl_err3("upd","tqe_file",g_tqe_t.tqe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                  LET g_tqe[l_ac].* = g_tqe_t.*
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()       
          #LET l_ac_t = l_ac   #FUN-D30033 mark             
           IF INT_FLAG THEN               
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_tqe[l_ac].* = g_tqe_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tqe.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i217_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE i217_bcl
           COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i217_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(tqe06) #financial
                  CALL cl_init_qry_var()                                       
                  LET g_qryparam.form ="q_aag07"    
#                 LET g_qryparam.where =" aag07 != '1' AND aag03 ='2' 
#                     AND aag00= '",g_aaz.aaz64,"'"
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_tqe[l_ac].tqe06
                  DISPLAY BY NAME g_tqe[l_ac].tqe06
                  NEXT FIELD tqe06
  
             WHEN INFIELD(tqe07) #management
                  CALL cl_init_qry_var()                                       
                  LET g_qryparam.form ="q_aag07"           
#                 LET g_qryparam.where =" aag07 != '1' AND aag03 IN ('2') 
#                     AND aag00= '",g_aaz.aaz66,"'"              
                  LET g_qryparam.arg1 = g_aza.aza82  #No.FUN-730033
                  CALL cl_create_qry() RETURNING g_tqe[l_ac].tqe07
                  DISPLAY BY NAME g_tqe[l_ac].tqe07
                  NEXT FIELD tqe07
           END CASE
 
        ON ACTION CONTROLO                     #沿用所有欄位
           IF INFIELD(tqe01) AND l_ac > 1 THEN
              LET g_tqe[l_ac].* = g_tqe[l_ac-1].*
              DISPLAY g_tqe[l_ac].* TO s_tqe[l_ac].*
              NEXT FIELD tqe01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
           RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
    
        ON ACTION help          
           CALL cl_show_help()  
        
        END INPUT
 
    CLOSE i217_bcl
    COMMIT WORK
END FUNCTION
   
 
FUNCTION i217_b_fill(p_wc)                     #BODY FILL UP
 
    DEFINE p_wc    LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(300)
 
    LET g_sql= "SELECT tqe01,tqe02,tqe03,",
               "       tqe04,tqe05,tqe11,tqe12,tqe06,'',tqe09,",  
               "       tqe07,'',tqe10,tqe08,tqeacti ", 
               "  FROM tqe_file",
               " WHERE  ",p_wc CLIPPED,
               " ORDER BY tqe01"
    PREPARE i217_prepare FROM g_sql            #預備一下
    DECLARE i217_cs CURSOR FOR i217_prepare
 
    CALL g_tqe.clear()
    LET g_cnt = 1
    FOREACH i217_cs INTO   g_tqe[g_cnt].*      #單身 ARRAY 填充                        
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
        
    SELECT aag02 INTO  g_tqe[g_cnt].aag02
      FROM aag_file
     WHERE aag01=g_tqe[g_cnt].tqe06
       AND aag00=g_aza.aza81  #No.FUN-730033
         
    SELECT aag02 INTO  g_tqe[g_cnt].aag02a
      FROM aag_file
     WHERE aag01=g_tqe[g_cnt].tqe07
       AND aag00=g_aza.aza82  #No.FUN-730033
        
    LET g_cnt= g_cnt + 1 
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
    END IF
    END FOREACH
 
    CALL g_tqe.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
    END IF
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i217_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqe TO s_tqe.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel                                                                                                       
         LET g_action_choice = 'exporttoexcel'                                                                                      
         EXIT DISPLAY      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i217_set_entry_tqe03(p_cmd)    
   DEFINE p_cmd   LIKE tqe_file.tqe03
   IF p_cmd = '4' THEN                                             
      CALL cl_set_comp_entry("tqe12",TRUE)   
   END IF
END FUNCTION                                                                    
                                                                                
FUNCTION i217_set_no_entry_tqe03(p_cmd)    
   DEFINE p_cmd   LIKE tqe_file.tqe03
   IF p_cmd <> '4' OR cl_null(p_cmd) THEN 
      CALL cl_set_comp_entry("tqe12",FALSE)   
   END IF
END FUNCTION                                                                    
