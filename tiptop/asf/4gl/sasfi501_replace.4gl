# Prog. Version..: '5.30.06-13.04.22(00009)'     #
# 
# Pattern name...: sasfi501_replace.4gl 
# Descriptions...: 配方替代 
# Date & Author..: No.TQC-B90236 11/10/24 By yuhuabao 
# Modify.........: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify.........: No.TQC-C20499 12/02/27 By zhuhao 單身應發量(sqty)應不可維護，欄位值=發料量*替代率/100
# Modify.........: No.TQC-C20507 12/02/28 By zhuhao 配方替代的批序號維護，折合量=實際發料量*purity/100
# Modify.........: No.TQC-C20508 12/02/28 By yuhuabao 每筆單身回寫temp後，一併更新回扣料數量
# Modify.........: No.TQC-C20509 12/02/28 By yuhuabao 配方替代，批序號維護，第一次進來時應直接進入資料擷取的qbe狀態
# Modify.........: No.TQC-C20506 12/02/29 By yuhuabao 配方替代的批序號維護，第一次資料擷取時，特性資料沒有顯示
# Modify.........: No.TQC-C20569 12/02/29 By yuhuabao  配方替代，asf1022訊息檢查，應判斷，該料號要做批序號管理才需檢查
# Modify.........: No.TQC-C20568 12/02/29 By yuhuabao  批序號維護，如有資料則顯示，無則進入QBE
# Modify.........: No.TQC-C20574 12/03/01 By yuhuabao  當前料號需要做批序號管理才可進行批序號維護
# Modify.........: No.TQC-C20575 12/03/01 By yuhuabao  配方替代，不要一進單身就開批序號維護窗，請於數量有變更時再開就好了
# Modify.........: No.TQC-C30010 12/03/01 By yuhuabao  配方替代維護完，確定離開後，資料沒回寫發料單單身
# Modify.........: No.TQC-C30028 12/03/02 By yuhuabao  配方替代單身於替代率前加顯示"底數"(bmd10)，應發量sqty改為發料量*替代率/底數
# Modify.........: No.TQC-C30067 12/03/03 By wuxj      成套退料時隱藏資料攫取action
# Modify.........: No.MOD-C30465 12/03/15 By zhuhao 抓取配方替代的資料(bmd_file)時，應抓取主件(sfb05=bmd08)及元件(sfs27=bmd01)都相符的資料才顯示
# Modify.........: No.DEV-D40013 13/04/22 By Mandy 純過單用

DATABASE ds


GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi501.global1"

DEFINE  g_old_item    LIKE ima_file.ima01,
        g_old_ima02   LIKE ima_file.ima02,
        g_old_ima021  LIKE ima_file.ima021,
        g_old_sfs03   LIKE sfs_file.sfs03,
        g_old_sfs10   LIKE sfs_file.sfs10,
        g_old_sfs05   LIKE sfs_file.sfs05,
        g_old_sfs06   LIKE sfs_file.sfs06
DEFINE  g_rvbs021           LIKE rvbs_file.rvbs021,   
        g_rvbs_ima02        LIKE ima_file.ima02,
        g_rvbs_ima021       LIKE ima_file.ima021,
        g_rvbs_ounit        LIKE img_file.img09,
        g_rvbs_oqty         LIKE rvbs_file.rvbs06,
        g_rvbs_sunit        LIKE img_file.img09,     
        g_rvbs_fac          LIKE img_file.img34,       
        g_rvbs_sqty         LIKE rvbs_file.rvbs06,
        g_imgs02            LIKE imgs_file.imgs02,
        g_imgs03            LIKE imgs_file.imgs03,
        g_imgs04            LIKE imgs_file.imgs04

DEFINE   g_argv_1    LIKE ima_file.ima01,
         g_argv_2    LIKE sfs_file.sfs03,
         g_argv_3    LIKE sfs_file.sfs10,
         g_argv_4    LIKE sfs_file.sfs05,
         g_argv_5    LIKE sfs_file.sfs06
DEFINE   g_argv_6    LIKE  ima_file.ima01,
         g_argv_7    LIKE  sfs_file.sfs06,
         g_argv_8    LIKE  rvbs_file.rvbs06,
         g_argv_9    LIKE  img_file.img09,
         g_argv_10   LIKE  sfs_file.sfs07,
         g_argv_11   LIKE  sfs_file.sfs08,
         g_argv_12   LIKE  sfs_file.sfs09

DEFINE  g_new_sfs     DYNAMIC ARRAY OF RECORD
           sfs02      LIKE sfs_file.sfs02,
           ima01      LIKE ima_file.ima01,
           ima02      LIKE ima_file.ima02,
           ima021     LIKE ima_file.ima021,
           bmd10      LIKE bmd_file.bmd10,       #No.TQC-C30028
           bmd11      LIKE bmd_file.bmd11,
           bmd07      LIKE bmd_file.bmd07,
           sfs07      LIKE sfs_file.sfs07,
           sfs08      LIKE sfs_file.sfs08,
           sfs09      LIKE sfs_file.sfs09,
           sqty       LIKE rvbs_file.rvbs06,
           qty        LIKE rvbs_file.rvbs06,
           eqty       LIKE rvbs_file.rvbs06,
           img10      LIKE img_file.img10
END RECORD

DEFINE  g_new_sfs_t     RECORD
           sfs02      LIKE sfs_file.sfs02,
           ima01      LIKE ima_file.ima01,
           ima02      LIKE ima_file.ima02,
           ima021     LIKE ima_file.ima021,
           bmd10      LIKE bmd_file.bmd10,       #No.TQC-C30028
           bmd11      LIKE bmd_file.bmd11,
           bmd07      LIKE bmd_file.bmd07,
           sfs07      LIKE sfs_file.sfs07,
           sfs08      LIKE sfs_file.sfs08,
           sfs09      LIKE sfs_file.sfs09,
           sqty       LIKE rvbs_file.rvbs06,
           qty        LIKE rvbs_file.rvbs06,
           eqty       LIKE rvbs_file.rvbs06,
           img10      LIKE img_file.img10
END RECORD

DEFINE  g_lot_rvbs        DYNAMIC ARRAY OF RECORD
           sel        LIKE type_file.chr1,
           rvbs03     LIKE rvbs_file.rvbs03,
           rvbs04     LIKE rvbs_file.rvbs04,
           rvbs05     LIKE rvbs_file.rvbs05,
           imgs08     LIKE imgs_file.imgs08,
           rvbs07     LIKE rvbs_file.rvbs07,
           rvbs08     LIKE rvbs_file.rvbs08,
           rvbs06     LIKE rvbs_file.rvbs06,
           rvbs_eqty  LIKE rvbs_file.rvbs06,
           att01      LIKE imac_file.imac05,
           att02      LIKE imac_file.imac05,
           att03      LIKE imac_file.imac05,
           att04      LIKE imac_file.imac05,
           att05      LIKE imac_file.imac05,
           att06      LIKE imac_file.imac05,
           att07      LIKE imac_file.imac05,
           att08      LIKE imac_file.imac05,
           att09      LIKE imac_file.imac05,
           att10      LIKE imac_file.imac05
END RECORD

DEFINE  g_lot_rvbs_t      RECORD
           sel        LIKE type_file.chr1,
           rvbs03     LIKE rvbs_file.rvbs03,
           rvbs04     LIKE rvbs_file.rvbs04,
           rvbs05     LIKE rvbs_file.rvbs05,
           imgs08     LIKE imgs_file.imgs08,
           rvbs07     LIKE rvbs_file.rvbs07,
           rvbs08     LIKE rvbs_file.rvbs08,
           rvbs06     LIKE rvbs_file.rvbs06,
           rvbs_eqty  LIKE rvbs_file.rvbs06,
           att01      LIKE imac_file.imac05,
           att02      LIKE imac_file.imac05,
           att03      LIKE imac_file.imac05,
           att04      LIKE imac_file.imac05,
           att05      LIKE imac_file.imac05,
           att06      LIKE imac_file.imac05,
           att07      LIKE imac_file.imac05,
           att08      LIKE imac_file.imac05,
           att09      LIKE imac_file.imac05,
           att10      LIKE imac_file.imac05
END RECORD

DEFINE g_imac       DYNAMIC ARRAY OF RECORD
          imac04    LIKE imac_file.imac04
END RECORD
 
DEFINE g_chr           LIKE type_file.chr1  
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_forupd_sql STRING,
       g_sql           STRING, 
       g_rec_b,g_rec_b2         LIKE type_file.num5,   
       l_ac,l_ac2            LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_rvbs_srvbs06        LIKE rvbs_file.rvbs06
DEFINE g_rvbs_seqty          LIKE rvbs_file.rvbs06
FUNCTION i501_replace_item_no(p_sfs27,p_sfs03,p_sfs10,p_sfs05_sum,p_sfs06)
DEFINE   p_sfs27     LIKE  sfs_file.sfs27,    #被替代料號
         p_sfs03     LIKE  sfs_file.sfs03,    #工單單號
         p_sfs10     LIKE  sfs_file.sfs10,    #作業編號
         p_sfs05_sum LIKE  sfs_file.sfs05,    #發料量
         p_sfs06     LIKE  sfs_file.sfs06     #發料單位

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_argv_1 = p_sfs27
   LET g_argv_2 = p_sfs03
   LET g_argv_3 = p_sfs10
   LET g_argv_4 = p_sfs05_sum
   LET g_argv_5 = p_sfs06
   IF cl_null(g_argv_4) THEN LET g_argv_4 = 0 END IF
   DROP TABLE bmd_temp
   CREATE TEMP TABLE bmd_temp(
           sfs02      LIKE sfs_file.sfs02,
           ima01      LIKE ima_file.ima01,
           ima02      LIKE ima_file.ima02,
           ima021     LIKE ima_file.ima021,
           bmd10      LIKE bmd_file.bmd10,       #No.TQC-C30028
           bmd11      LIKE bmd_file.bmd11,
           bmd07      LIKE bmd_file.bmd07,
           sfs07      LIKE sfs_file.sfs07,
           sfs08      LIKE sfs_file.sfs08,
           sfs09      LIKE sfs_file.sfs09,
           sqty       LIKE rvbs_file.rvbs06,
           qty        LIKE rvbs_file.rvbs06,
           eqty       LIKE rvbs_file.rvbs06,
           img10      LIKE img_file.img10)

   DROP TABLE rvbs_temp
   CREATE TEMP TABLE rvbs_temp(
           rvbs021    LIKE rvbs_file.rvbs021,
           sel        LIKE type_file.chr1,
           rvbs03     LIKE rvbs_file.rvbs03,
           rvbs04     LIKE rvbs_file.rvbs04,
           rvbs05     LIKE rvbs_file.rvbs05,
           imgs08     LIKE imgs_file.imgs08,
           rvbs07     LIKE rvbs_file.rvbs07,
           rvbs08     LIKE rvbs_file.rvbs08,
           rvbs06     LIKE rvbs_file.rvbs06,
           rvbs_eqty  LIKE rvbs_file.rvbs06)
           
   OPEN WINDOW i501_replace_w  WITH FORM "asf/42f/sasfi501_replace" 
     ATTRIBUTE( STYLE = g_win_style ) 
   CALL cl_ui_locale("sasfi501_replace")
   CALL cl_set_comp_visible("sfs02",FALSE)
   CALL g_new_sfs.clear()
   CALL i501_replace_show()
   CALL i501_replace_menu()
   CLOSE WINDOW i501_replace_w

END FUNCTION

FUNCTION i501_replace_menu() 
  
   WHILE TRUE 
      CALL i501_replace_bp("G") 
      CASE g_action_choice 
         WHEN "detail" 
            CALL i501_replace_b() 
         WHEN "help" 
            CALL cl_show_help() 
         WHEN "exit" 
            LET INT_FLAG = 0 
            EXIT WHILE 
         WHEN "controlg" 
            CALL cl_cmdask() 

      END CASE 
   END WHILE 
  
END FUNCTION

FUNCTION i501_replace_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN 
      RETURN 
   END IF 
  
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_new_sfs TO s_new_sfs.* ATTRIBUTE(COUNT=g_rec_b) 
  
      BEFORE ROW 
         LET l_ac = ARR_CURR() 
         CALL cl_show_fld_cont()  
  
      ON ACTION detail 
         LET g_action_choice="detail" 
         LET l_ac = 1 
         EXIT DISPLAY 
  
      ON ACTION locale 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont() 
  
      ON ACTION help 
         LET g_action_choice="help" 
         EXIT DISPLAY 
  
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE DISPLAY 
  
      AFTER DISPLAY 
         CONTINUE DISPLAY 
  
      ON ACTION controls 
         LET g_action_choice="controls" 
         EXIT DISPLAY   
  
   END DISPLAY 
  
   CALL cl_set_act_visible("accept,cancel", TRUE) 
  
END FUNCTION

FUNCTION i501_replace_show()
   LET  g_old_item  =  g_argv_1
   LET  g_old_sfs03 =  g_argv_2
   LET  g_old_sfs10 =  g_argv_3
   LET  g_old_sfs05 =  g_argv_4
   LET  g_old_sfs06 =  g_argv_5

   DISPLAY  g_old_item,g_old_sfs03,g_old_sfs10,g_old_sfs05,g_old_sfs06
        TO  FORMONLY.old_item,FORMONLY.old_sfs03,FORMONLY.old_sfs10,
            FORMONLY.old_sfs05,FORMONLY.old_sfs06
   SELECT ima02,ima021 INTO g_old_ima02,g_old_ima021 FROM ima_file
    WHERE ima01 = g_old_item

   DISPLAY g_old_ima02,g_old_ima021 TO  FORMONLY.old_ima02,FORMONLY.old_ima021
   CALL i501_replace_b_fill()   
END FUNCTION 

FUNCTION i501_replace_b()
DEFINE
        l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
        l_n             LIKE type_file.num5,                #檢查重複用               
        l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
        p_cmd           LIKE type_file.chr1,                #處理狀態  
        p_flag          LIKE type_file.chr1,                #修改状态
        l_allow_insert  LIKE type_file.num5,                #可新增否 
        l_allow_delete  LIKE type_file.num5                 #可刪除否
DEFINE  l_sum_qty       LIKE rvbs_file.rvbs06,
        l_ima918        LIKE ima_file.ima918,
        l_ima921        LIKE ima_file.ima921,               #TQC-C20574 add
        l_buf           LIKE imd_file.imd02,
        l_ima108        LIKE ima_file.ima108,
        l_ima159        LIKE ima_file.ima159
DEFINE  li_i            LIKE type_file.num5                #No.TQC-C20508 add
        

   LET g_action_choice = ""
   IF s_shut(0) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')
   
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_new_sfs WITHOUT DEFAULTS FROM s_new_sfs.*
       ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,                                           
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,           
                 APPEND ROW=l_allow_insert)                              
  
      BEFORE INPUT 
         IF g_rec_b != 0 THEN 
            CALL fgl_set_arr_curr(l_ac) 
         END IF 

      BEFORE ROW 
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK 
         IF g_rec_b >= l_ac THEN 
            LET p_cmd = 'u'
            LET g_new_sfs_t.* = g_new_sfs[l_ac].*
#No.TQC-C20575 ----- mark ----- begin
#           SELECT ima918 INTO l_ima918 FROM ima_file
#            WHERE ima01 = g_new_sfs[l_ac].ima01
#           IF l_ima918='Y' THEN
#              CALL i501_replace_mod_lot(g_new_sfs[l_ac].ima01,g_old_sfs06,
#                                        g_new_sfs[l_ac].sqty,g_new_sfs[l_ac].sfs07,
#                                        g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09)
#                 RETURNING g_new_sfs[l_ac].qty,g_new_sfs[l_ac].eqty
#              DISPLAY g_new_sfs[l_ac].qty TO FORMONLY.qty
#              DISPLAY  g_new_sfs[l_ac].eqty TO FORMONLY.eqty
#           END IF
#No.TQC-C20575 ----- mark ----- end
         END IF 

      AFTER FIELD sfs07
&ifdef ICD
           #若已有idb存在不可修改
         IF g_sfp.sfp06 MATCHES '[12346789]' THEN
            IF p_cmd = 'u' AND NOT cl_null(g_new_sfs[l_ac].sfs07) THEN
               IF g_new_sfs_t.sfs07 <> g_new_sfs[l_ac].sfs07 THEN
                  CALL i501_replace_ind_icd_chk_icd()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_new_sfs[l_ac].sfs07 = g_new_sfs_t.sfs07
                     NEXT FIELD sfs07
                  END IF
               END IF
            END IF
         END IF
         IF NOT s_icdout_holdlot(g_new_sfs[l_ac].ima01,g_new_sfs[l_ac].sfs07,
                                   g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09) THEN
              NEXT FIELD sfs07
         END IF
&endif
         IF NOT cl_null(g_new_sfs[l_ac].sfs07) THEN
            SELECT imd02 INTO l_buf FROM imd_file 
             WHERE imd01=g_new_sfs[l_ac].sfs07
               AND imdacti = 'Y' 
            IF STATUS THEN
               CALL cl_err3("sel","imd_file",g_new_sfs[l_ac].sfs07,"",STATUS,"","sel imd",1)  
               NEXT FIELD sfs07
            END IF
            SELECT ima108 INTO l_ima108 FROM ima_file
             WHERE ima01=g_new_sfs[l_ac].ima01
            IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
               SELECT COUNT(*) INTO l_n FROM imd_file
                WHERE imd01=g_new_sfs[l_ac].sfs07 AND imd10='W'
                  AND imdacti = 'Y'
               LET g_msg = g_new_sfs[l_ac].ima01," ",g_new_sfs[l_ac].sfs07  
               IF l_n = 0 THEN                   
                  CALL cl_err(g_msg,'asf-724',0) NEXT FIELD sfs07
               END IF
            END IF
            IF g_azw.azw04 = '2' THEN 
               IF NOT s_chk_ware(g_new_sfs[l_ac].sfs07) THEN  #检查仓库是否属于当前门店
                  NEXT FIELD sfs07
               END IF
            END IF 
         END IF
      AFTER FIELD sfs08
           # 控管是否為全型空白
         IF g_new_sfs[l_ac].sfs08 = '　' THEN #全型空白
            LET g_new_sfs[l_ac].sfs08 = ' '
         END IF
         IF g_new_sfs[l_ac].sfs08 IS NULL THEN LET g_new_sfs[l_ac].sfs08 =' ' END IF
&ifdef ICD
           #若已有idb存在不可修改
         IF g_sfp.sfp06 MATCHES '[12346789]' THEN 
            IF p_cmd = 'u' AND NOT cl_null(g_new_sfs[l_ac].sfs08) THEN
               IF g_new_sfs_t.sfs08 <> g_new_sfs[l_ac].sfs08 THEN
                  CALL i501_replace_ind_icd_chk_icd()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_new_sfs[l_ac].sfs08 = g_new_sfs_t.sfs08
                     NEXT FIELD sfs08
                  END IF
               END IF
            END IF
         END IF
         IF NOT s_icdout_holdlot(g_new_sfs[l_ac].ima01,g_new_sfs[l_ac].sfs07,
                                   g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09) THEN
            NEXT FIELD sfs08
         END IF
&endif
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
         IF NOT s_chksmz(g_new_sfs[l_ac].ima01,g_sfp.sfp01,
                         g_new_sfs[l_ac].sfs07,g_new_sfs[l_ac].sfs08) THEN
            NEXT FIELD sfs07
         END IF

         IF NOT cl_null(g_new_sfs[l_ac].ima01) THEN
            SELECT ima159 INTO l_ima159 FROM ima_file
             WHERE ima01 = g_new_sfs[l_ac].ima01
            IF l_ima159 = '2' THEN
               CASE i501_replace_b_sfs09_inschk(p_cmd)
                    WHEN "sfs07" NEXT FIELD sfs07
                    WHEN "sfs09" NEXT FIELD sfs07
               END CASE
            END IF
         END IF

      AFTER FIELD sfs09
           CASE i501_replace_b_sfs09_inschk(p_cmd)
              WHEN "sfs07" NEXT FIELD sfs07
              WHEN "sfs09" NEXT FIELD sfs09
           END CASE
         
      AFTER FIELD qty
         IF NOT cl_null(g_new_sfs[l_ac].qty) THEN
            IF g_new_sfs[l_ac].qty < 0 THEN 
               CALL cl_err('','art-040',0)
               LET g_new_sfs[l_ac].qty = g_new_sfs_t.qty
               DISPLAY g_new_sfs[l_ac].qty TO qty
               NEXT FIELD qty
            END IF
#No.TQC-C20575 ----- mark ----- begin
#           IF l_ima918 <> 'Y' OR cl_null(l_ima918) THEN
#              LET  g_new_sfs[l_ac].eqty = g_new_sfs[l_ac].qty
#              DISPLAY  g_new_sfs[l_ac].eqty TO FORMONLY.eqty
#           END IF 
#No.TQC-C20575 ----- mark ----- end
        END IF

#No.TQC-C20575 ----- add ----- begin
      ON CHANGE qty
            SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
             WHERE ima01 = g_new_sfs[l_ac].ima01
            IF l_ima918='Y' OR l_ima921 = 'Y' THEN
               CALL i501_replace_mod_lot(g_new_sfs[l_ac].ima01,g_old_sfs06,
                                         g_new_sfs[l_ac].sqty,g_new_sfs[l_ac].sfs07,
                                         g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09)
                  RETURNING g_new_sfs[l_ac].qty,g_new_sfs[l_ac].eqty
               LET g_new_sfs_t.qty = g_new_sfs[l_ac].qty
               DISPLAY g_new_sfs[l_ac].qty TO FORMONLY.qty
               DISPLAY  g_new_sfs[l_ac].eqty TO FORMONLY.eqty
            ELSE
               LET  g_new_sfs[l_ac].eqty = g_new_sfs[l_ac].qty
               DISPLAY  g_new_sfs[l_ac].eqty TO FORMONLY.eqty
            END IF
#No.TQC-C20575 ----- add ----- end
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_new_sfs[l_ac].* = g_new_sfs_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_new_sfs[l_ac].sfs02,-263,1)
            LET g_new_sfs[l_ac].* = g_new_sfs_t.*
         ELSE         
            UPDATE bmd_temp SET sfs07 = g_new_sfs[l_ac].sfs07,
                                sfs08 = g_new_sfs[l_ac].sfs08,
                                sfs09 = g_new_sfs[l_ac].sfs09,
                                qty   = g_new_sfs[l_ac].qty,
                                eqty  = g_new_sfs[l_ac].eqty
             WHERE sfs02 = g_new_sfs_t.sfs02
               AND ima01 = g_new_sfs_t.ima01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","bmd_temp",g_new_sfs_t.ima01,g_new_sfs_t.sfs02,SQLCA.sqlcode,"","",1) 
               LET g_new_sfs[l_ac].* = g_new_sfs_t.*
            ELSE
#TQC-C20508 ----- add ----- begin
#每筆單身回寫temp後，一併更新回扣料數量
               SELECT SUM(qty) INTO l_sum_qty FROM bmd_temp WHERE bmd11 = 'N'
               IF cl_null(l_sum_qty) THEN
                  LET l_sum_qty = 0
               END IF
               FOR li_i = 1 TO g_new_sfs.getLength()
                  IF g_new_sfs[li_i].bmd11 = 'Y' THEN
                     LET  g_new_sfs[li_i].qty = g_old_sfs05 - l_sum_qty
                     LET  g_new_sfs[li_i].eqty = g_old_sfs05 - l_sum_qty
                  END IF
               END FOR
               UPDATE bmd_temp SET qty  = g_old_sfs05 - l_sum_qty,
                                   eqty = g_old_sfs05 - l_sum_qty
                WHERE bmd11 = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","bmd_temp",'','',SQLCA.sqlcode,"","",1)
               ELSE
#TQC-C20508 ----- add ----- end
                  MESSAGE 'UPDATE O.K' 
                  COMMIT WORK
               END IF         #TQC-C20508 add
            END IF
         END IF 

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'a' THEN
               CALL g_new_sfs.deleteElement(l_ac)
            END IF
            IF p_cmd = 'u' THEN
               LET g_new_sfs[l_ac].* = g_new_sfs_t.*
            END IF
            ROLLBACK WORK 
            EXIT INPUT
         END IF
         COMMIT WORK
         
      AFTER INPUT
         IF NOT i501_replace_chk() THEN
            CONTINUE INPUT 
         END IF 

      ON ACTION modi_lot
#TQC-C20574 ----- add ----- begin
         SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
          WHERE ima01 = g_new_sfs[l_ac].ima01
         IF l_ima918 = 'Y' OR l_ima921 = 'Y' THEN
#TQC-C20574 ----- add ----- end 
            CALL i501_replace_mod_lot(g_new_sfs[l_ac].ima01,g_old_sfs06,
                                      g_new_sfs[l_ac].sqty,g_new_sfs[l_ac].sfs07,
                                      g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09)
             RETURNING g_new_sfs[l_ac].qty,g_new_sfs[l_ac].eqty
             DISPLAY g_new_sfs[l_ac].qty TO FORMONLY.qty
             DISPLAY  g_new_sfs[l_ac].eqty TO FORMONLY.eqty
         ELSE                                      #TQC-C20574 add
            CALL cl_err('','aim1106',0)            #TQC-C20574 add
         END IF                                    #TQC-C20574 add
         
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(sfs07) OR INFIELD(sfs08) OR INFIELD(sfs09)
               CALL q_img4(FALSE,TRUE,g_new_sfs[l_ac].ima01,g_new_sfs[l_ac].sfs07,
                           g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09,'A')
                 RETURNING g_new_sfs[l_ac].sfs07,g_new_sfs[l_ac].sfs08,
                           g_new_sfs[l_ac].sfs09
               DISPLAY g_new_sfs[l_ac].sfs07 TO sfs07
               DISPLAY g_new_sfs[l_ac].sfs08 TO sfs08
               DISPLAY g_new_sfs[l_ac].sfs09 TO sfs09
               IF INFIELD(sfs07) THEN NEXT FIELD sfs07 END IF
               IF INFIELD(sfs08) THEN NEXT FIELD sfs08 END IF
               IF INFIELD(sfs09) THEN NEXT FIELD sfs09 END IF
         END CASE 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()  
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")    
   END INPUT
#TQC-C20508 ----- mark ----- begin
#  #資料回寫發料單身
#  SELECT SUM(qty) INTO l_sum_qty FROM bmd_temp WHERE bmd11 = 'N'
#  IF cl_null(l_sum_qty) THEN
#     LET l_sum_qty = 0 
#  END IF
#  UPDATE bmd_temp SET qty  = g_old_sfs05 - l_sum_qty,
#                      eqty = g_old_sfs05 - l_sum_qty
#   WHERE bmd11 = 'Y'
#  IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","bmd_temp",'','',SQLCA.sqlcode,"","",1)
#  END IF
#TQC-C20508 ----- mark ----- end
   CALL i501_replace_write_back()
   COMMIT WORK
   
END FUNCTION 
#資料正確性的檢查
FUNCTION  i501_replace_chk()
DEFINE    l_sum_qty    LIKE   rvbs_file.rvbs06
DEFINE    l_sum_rvbs06 LIKE   rvbs_file.rvbs06
DEFINE    l_bmd_temp  RECORD 
           sfs02      LIKE sfs_file.sfs02,
           ima01      LIKE ima_file.ima01,
           ima02      LIKE ima_file.ima02,
           ima021     LIKE ima_file.ima021,
           bmd10      LIKE bmd_file.bmd10,       #No.TQC-C30028
           bmd11      LIKE bmd_file.bmd11,
           bmd07      LIKE bmd_file.bmd07,
           sfs07      LIKE sfs_file.sfs07,
           sfs08      LIKE sfs_file.sfs08,
           sfs09      LIKE sfs_file.sfs09,
           sqty       LIKE rvbs_file.rvbs06,
           qty        LIKE rvbs_file.rvbs06,
           eqty       LIKE rvbs_file.rvbs06,
           img10      LIKE img_file.img10
END RECORD
DEFINE   l_ima918     LIKE ima_file.ima918     #TQC-C20569  add
DEFINE   l_ima921     LIKE ima_file.ima921     #wuxj  add 
  #檢查總數量
   SELECT SUM(qty) INTO l_sum_qty FROM bmd_temp
   IF cl_null(l_sum_qty) THEN
      LET l_sum_qty = 0
   END IF
   IF l_sum_qty <> g_old_sfs05 THEN
      CALL cl_err('','asf1021',0)
      RETURN FALSE
   END IF 
   #檢查單身資料的合理性
   DECLARE replace_chk_cs CURSOR FOR 
          SELECT * FROM bmd_temp WHERE qty <> 0
   FOREACH replace_chk_cs INTO l_bmd_temp.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 
      #發號量需與批號數量相等
#    #SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file 
      SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_temp 
       WHERE rvbs021 = l_bmd_temp.ima01
      IF cl_null(l_sum_rvbs06) THEN
         LET l_sum_rvbs06 = 0 
      END IF

      SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file  #TQC-C20569  add
       WHERE ima01 = l_bmd_temp.ima01            #TQC-C20569  add
   
      IF (l_ima918 = 'Y'OR l_ima921 = 'Y')  THEN  #TQC-C20569  add l_ima918
         IF l_bmd_temp.qty <> l_sum_rvbs06 THEN 
            CALL cl_err(l_bmd_temp.ima01,'asf1022',0)
            RETURN FALSE 
         END IF 
      END IF 
      #非回扣料折合量與應發量需相符
      IF l_bmd_temp.bmd11 = 'N' THEN 
         IF l_bmd_temp.eqty <> l_bmd_temp.sqty THEN 
            CALL cl_err(l_bmd_temp.ima01,'asf1023',0)
            RETURN FALSE
         END IF 
      END IF       
   END FOREACH 
   RETURN TRUE
END FUNCTION

#資料回寫發料單身
FUNCTION i501_replace_write_back()
DEFINE  o_sfs         RECORD  LIKE  sfs_file.*
DEFINE  n_sfs         RECORD  LIKE  sfs_file.*
DEFINE  l_n           LIKE  type_file.num5
DEFINE  l_sfs02       LIKE  sfs_file.sfs02
DEFINE  l_ima918      LIKE  ima_file.ima918
DEFINE  l_ima921      LIKE  ima_file.ima921    #TQC-C30010 add
DEFINE  l_rvbs022     LIKE  rvbs_file.rvbs022
DEFINE  l_bmd_tmp     RECORD
           sfs02      LIKE sfs_file.sfs02,
           ima01      LIKE ima_file.ima01,
           ima02      LIKE ima_file.ima02,
           ima021     LIKE ima_file.ima021,
           bmd10      LIKE bmd_file.bmd10,     #TQC-C30028 add
           bmd11      LIKE bmd_file.bmd11,
           bmd07      LIKE bmd_file.bmd07,
           sfs07      LIKE sfs_file.sfs07,
           sfs08      LIKE sfs_file.sfs08,
           sfs09      LIKE sfs_file.sfs09,
           sqty       LIKE rvbs_file.rvbs06,
           qty        LIKE rvbs_file.rvbs06,
           eqty       LIKE rvbs_file.rvbs06,
           img10      LIKE img_file.img10
END RECORD
DEFINE  l_rvbs_tmp    RECORD
           rvbs021    LIKE rvbs_file.rvbs021,
           sel        LIKE type_file.chr1,
           rvbs03     LIKE rvbs_file.rvbs03,
           rvbs04     LIKE rvbs_file.rvbs04,
           rvbs05     LIKE rvbs_file.rvbs05,
           imgs08     LIKE imgs_file.imgs08,
           rvbs07     LIKE rvbs_file.rvbs07,
           rvbs08     LIKE rvbs_file.rvbs08,
           rvbs06     LIKE rvbs_file.rvbs06,
           rvbs_eqty  LIKE rvbs_file.rvbs06
END RECORD 
DEFINE  l_att      LIKE rvbs_file.rvbs09   #TQC-C30067
   LET g_success = 'Y'
   IF g_prog = 'asfi511' THEN LET l_att = -1 END IF
   IF g_prog = 'asfi526' THEN LET l_att = 1  END IF
   
   BEGIN WORK 
   SELECT * INTO o_sfs.* FROM sfs_file 
    WHERE sfs01=g_sfp.sfp01 AND sfs04=g_old_item 
      AND sfs03=g_old_sfs03 AND sfs10=g_old_sfs10

   SELECT COUNT(*) INTO l_n FROM sfs_file             
    WHERE sfs01=g_sfp.sfp01 AND sfs04=g_old_item
      AND sfs03=g_old_sfs03 AND sfs10=g_old_sfs10

   IF l_n = 0 THEN 
      SELECT * INTO o_sfs.* FROM sfs_file 
       WHERE sfs01=g_sfp.sfp01 AND sfs27=g_old_item 
         AND sfs03=g_old_sfs03 AND sfs10=g_old_sfs10
   END IF 
   #以單身寫入發料檔
   DECLARE replace_back_cs CURSOR FOR 
         SELECT * FROM bmd_temp
   FOREACH  replace_back_cs INTO l_bmd_tmp.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
      LET l_sfs02 = 0  #TQC-C30028 add
      SELECT sfs02 INTO l_sfs02 FROM sfs_file
          WHERE sfs01 = g_sfp.sfp01
            AND sfs04 = l_bmd_tmp.ima01
            AND sfs27 = g_old_item
            AND sfs03 = g_old_sfs03
            AND sfs10 = g_old_sfs10
      IF l_bmd_tmp.qty = 0 THEN  #此次不替代
#         IF NOT cl_null(l_sfs02) THEN        #TQC-C30010 mark
         IF l_sfs02 > 0 THEN                  #TQC-C30010 add
            #刪除發料單身
            DELETE FROM sfs_file WHERE sfs01 = g_sfp.sfp01
                                   AND sfs04 = l_bmd_tmp.ima01
                                   AND sfs27 = g_old_item
                                   AND sfs03 = g_old_sfs03
                                   AND sfs10 = g_old_sfs10
            IF SQLCA.sqlcode THEN 
                CALL cl_err3("del","sfs_file","","",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
            END IF 
            #刪除批序號資料
            DELETE FROM rvbs_file WHERE rvbs00 = g_prog                  #TQC-C30067 asfi511->g_prog
                                    AND rvbs01 = g_sfp.sfp01
                                    AND rvbs02 = l_sfs02
                                    AND rvbs09 = l_att
                                    AND rvbs13 = 0
            IF SQLCA.sqlcode THEN                        
                CALL cl_err3("del","rvbs_file","","",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
            END IF 
         END IF 
      ELSE 
         SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file WHERE ima01 = l_bmd_tmp.ima01 #TQC-C30010 add ima921
#         IF NOT cl_null(l_sfs02) THEN             #TQC-C30010 mark
          IF l_sfs02 > 0 THEN                      #TQC-C30010 add
            #更新發料單身
            UPDATE sfs_file SET sfs07 = l_bmd_tmp.sfs07,
                                sfs08 = l_bmd_tmp.sfs08,
                                sfs09 = l_bmd_tmp.sfs09,
                                sfs05 = l_bmd_tmp.qty,
                                sfs32 = l_bmd_tmp.qty
             WHERE sfs01 = g_sfp.sfp01
               AND sfs04 = l_bmd_tmp.ima01
               AND sfs27 = g_old_item
               AND sfs03 = g_old_sfs03
               AND sfs10 = g_old_sfs10

            IF SQLCA.sqlcode THEN 
                CALL cl_err3("upd","sfs_file","","",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
            END IF
            IF l_ima918='Y' OR l_ima921='Y' THEN  #TQC-C30010 add ima921
               DELETE FROM rvbs_file WHERE rvbs00 = g_prog       #TQC-C30067 asfi511->g_prog
                                       AND rvbs01 = g_sfp.sfp01
                                       AND rvbs02 = l_sfs02
                                       AND rvbs09 = l_att
                                       AND rvbs13 = 0
               IF SQLCA.sqlcode THEN                         
                  CALL cl_err3("del","rvbs_file","","",SQLCA.sqlcode,"","",1)
                  LET g_success = 'N'
               END IF 
            END IF 
         ELSE 
            #新增發料單身
#           SELECT MAX(sfs02)+1 INTO n_sfs.sfs02 FROM sfs_file #TQC-C20575 mark
            LET n_sfs.* = o_sfs.*
            SELECT MAX(sfs02)+1 INTO l_sfs02 FROM sfs_file #TQC-C20575 add
             WHERE sfs01 = g_sfp.sfp01                         #TQC-C20575 add
            LET n_sfs.sfs02=l_sfs02                            #TQC-C20575 add
            LET n_sfs.sfs04=l_bmd_tmp.ima01
            LET n_sfs.sfs05=l_bmd_tmp.qty
            LET n_sfs.sfs07=l_bmd_tmp.sfs07
            LET n_sfs.sfs08=l_bmd_tmp.sfs08
            LET n_sfs.sfs09=l_bmd_tmp.sfs09
            IF l_bmd_tmp.bmd11 =  'N' THEN 
               LET n_sfs.sfs26 = 'B'
            ELSE
               LET n_sfs.sfs26 = 'C'
            END IF 
            LET n_sfs.sfs28 = 1
            LET n_sfs.sfs32=n_sfs.sfs05
            LET n_sfs.sfs35=0
            INSERT INTO sfs_file VALUES(n_sfs.*)
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("ins","sfs_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
         END IF
         #更新批序號資料            
         IF l_ima918='Y' OR l_ima921='Y' THEN              #TQC-C30010 add ima921
            DECLARE replace_back_rvbs_cs CURSOR FOR 
                    SELECT * FROM rvbs_temp WHERE rvbs021 = l_bmd_tmp.ima01
                                              AND sel     = 'Y'
                                              AND rvbs06 > 0
            LET l_rvbs022 = 1

            FOREACH replace_back_rvbs_cs INTO l_rvbs_tmp.*
               IF SQLCA.sqlcode THEN 
                  CALL cl_err('foreach',SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               INSERT INTO rvbs_file VALUES(g_prog,g_sfp.sfp01,l_sfs02,     #TQC-C30067 asfi511->g_prog
                                            l_rvbs_tmp.rvbs03,l_rvbs_tmp.rvbs04,
                                            l_rvbs_tmp.rvbs05,l_rvbs_tmp.rvbs06,
                                            l_rvbs_tmp.rvbs07,l_rvbs_tmp.rvbs08,
                                            l_bmd_tmp.ima01,l_rvbs022,l_att,0,0,0,0,
                                            g_plant,g_legal)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","",1)
                  LET g_success = 'N'
               END IF 
               LET l_rvbs022 = l_rvbs022 + 1
            END FOREACH
         END IF
      END IF
   END FOREACH

   #如果替代成功，則刪除被替代料
   SELECT count(*) INTO l_n FROM sfs_file WHERE sfs01 = g_sfp.sfp01
                                            AND sfs27 = g_old_item
                                            AND sfs03 = g_old_sfs03
                                            AND sfs10 = g_old_sfs10
                                            AND (sfs26='B' OR sfs26='C')
   IF l_n > 0 THEN
      DELETE FROM sfs_file WHERE sfs01 = g_sfp.sfp01
                             AND sfs04 = g_old_item
                             AND sfs27 = g_old_item
                             AND sfs03 = g_old_sfs03
                             AND sfs10 = g_old_sfs10
                             AND (sfs26='9' OR sfs26='A')  #TQC-C30028 add A
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","sfs_file","","",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF 
   END IF 
   IF g_success = 'Y' THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
   END IF 
END FUNCTION
  
FUNCTION i501_replace_b_fill()
DEFINE   l_imgs08     LIKE    imgs_file.imgs08
DEFINE   l_inj04      LIKE    inj_file.inj04
DEFINE   l_rvbs_eqty  LIKE  rvbs_file.rvbs06
DEFINE   l_rvbs       RECORD LIKE rvbs_file.*
   LET g_sql = "SELECT sfs02,sfs04,ima02,ima021,bmd10,bmd11,bmd07,sfs07,sfs08,sfs09,0,sfs05,0,0",   #TQC-C30028 add bmd10
               "  FROM sfs_file,bmd_file,ima_file,sfb_file",    #MOD-C30465 add sfb_file
               " WHERE bmd01='",g_old_item,"'",
               "   AND bmd04=sfs04",
               "   AND bmd02='3'",
               "   AND ima01=sfs04",
               "   AND sfs01='",g_sfp.sfp01,"'",
               "   AND sfs27='",g_old_item,"'",
               "   AND sfs03='",g_old_sfs03,"'",
               "   AND sfs10='",g_old_sfs10,"'",
               "   AND bmd08= sfb05",                     #MOD-C30465 add
               "   AND sfs03= sfb01",                     #MOD-C30465 add
               "  UNION  ",
               "SELECT 0,bmd04,ima02,ima021,bmd10,bmd11,bmd07,'','','',0,0,0,0", #TQC-C30028 add
               "  FROM bmd_file,ima_file,sfb_file",              #MOD-C30465 add sfb_file
               " WHERE bmd01='",g_old_item,"'", 
               "   AND ima01=bmd04",
               "   AND bmd02='3'",
               "   AND sfb01='",g_old_sfs03,"'",          #MOD-C30465 add
               "   AND bmd08= sfb05",                     #MOD-C30465 add
               "   AND bmd04 NOT IN (SELECT sfs04 FROM sfs_file", 
               "                      WHERE sfs01='",g_sfp.sfp01,"'", 
               "                        AND sfs27='",g_old_item,"'",  
               "                        AND sfs03='",g_old_sfs03,"'",
               "                        AND sfs10='",g_old_sfs10,"')"
               
   PREPARE i501_replace_pre  FROM g_sql
   DECLARE i501_replace_cs  CURSOR FOR  i501_replace_pre
   CALL g_new_sfs.clear()
   LET  g_cnt = 1
   FOREACH   i501_replace_cs INTO g_new_sfs[g_cnt].*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 

      IF g_new_sfs[g_cnt].sfs02 = 0 THEN 
         SELECT sfs07,sfs08,sfs09 INTO g_new_sfs[g_cnt].sfs07,g_new_sfs[g_cnt].sfs08,g_new_sfs[g_cnt].sfs09
           FROM sfs_file
          WHERE sfs01=g_sfp.sfp01
            AND sfs27=g_old_item
            AND sfs03=g_old_sfs03
            AND sfs10=g_old_sfs10
         IF SQLCA.sqlcode THEN 
            CALL cl_err('',SQLCA.sqlcode,0)
         END IF 
         IF cl_null(g_new_sfs[g_cnt].sfs07) THEN LET g_new_sfs[g_cnt].sfs07 = ' ' END IF
         IF cl_null(g_new_sfs[g_cnt].sfs08) THEN LET g_new_sfs[g_cnt].sfs08 = ' ' END IF
         IF cl_null(g_new_sfs[g_cnt].sfs09) THEN LET g_new_sfs[g_cnt].sfs09 = ' ' END IF
      ELSE 
         DECLARE rvbs_tmp_cs CURSOR FOR 
               SELECT * FROM rvbs_file WHERE rvbs00 = g_prog
                                         AND rvbs01 = g_sfp.sfp01
                                         AND rvbs02 = g_new_sfs[g_cnt].sfs02
                                         AND rvbs021 = g_new_sfs[g_cnt].ima01
          
         FOREACH rvbs_tmp_cs INTO l_rvbs.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF 
            #抓取庫存數量
            SELECT imgs08 INTO l_imgs08 FROM imgs_file
             WHERE imgs01=g_new_sfs[g_cnt].ima01 
               AND imgs02=g_new_sfs[g_cnt].sfs07
               AND imgs03=g_new_sfs[g_cnt].sfs08 
               AND imgs04=g_new_sfs[g_cnt].sfs09 
               AND imgs05=l_rvbs.rvbs03 
               AND imgs06=l_rvbs.rvbs04
            IF cl_null(l_imgs08) THEN
               LET l_imgs08 = 0
            END IF
            SELECT inj04 INTO l_inj04 FROM inj_file
             WHERE inj01 = g_new_sfs[g_cnt].ima01
               AND inj02 = l_rvbs.rvbs04
               AND inj03 = "purity"
            IF cl_null(l_inj04) THEN LET l_inj04 = 100 END IF 
            #单笔折合量
            LET l_rvbs_eqty = l_rvbs.rvbs06*l_inj04/100     #TQC-C20507 add '/100'
            #寫入rvbs_temp
            INSERT INTO rvbs_temp VALUES(l_rvbs.rvbs021,'Y',
                                         l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs05,
                                         l_imgs08,l_rvbs.rvbs07,l_rvbs.rvbs08,
                                         l_rvbs.rvbs06,l_rvbs_eqty)
                                         
         END FOREACH
         #總折合量
         SELECT SUM(rvbs_eqty) INTO g_new_sfs[g_cnt].eqty FROM rvbs_temp
          WHERE rvbs021 = g_new_sfs[g_cnt].ima01
         IF cl_null(g_new_sfs[g_cnt].eqty) THEN
            LET g_new_sfs[g_cnt].eqty = 0
         END IF
      END IF

      SELECT img10 INTO g_new_sfs[g_cnt].img10 FROM img_file
       WHERE img01 = g_new_sfs[g_cnt].ima01
         AND img02 = g_new_sfs[g_cnt].sfs07
         AND img03 = g_new_sfs[g_cnt].sfs08
         AND img04 = g_new_sfs[g_cnt].sfs09
      IF cl_null(g_new_sfs[g_cnt].img10)  THEN
         LET g_new_sfs[g_cnt].img10 = 0
      END IF

      #寫入bmd_temp
      LET g_new_sfs[g_cnt].sqty = g_new_sfs[g_cnt].bmd07*g_old_sfs05/g_new_sfs[g_cnt].bmd10       #TQC-C20499 add #TQC-C30028 modify 100->底數
      INSERT INTO bmd_temp VALUES(g_new_sfs[g_cnt].*)
      LET g_cnt = g_cnt + 1
   END FOREACH 
   CALL g_new_sfs.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
END FUNCTION 

#批序號維護
FUNCTION i501_replace_mod_lot(p_item,p_sfs06,p_sqty,p_new_sfs07,p_new_sfs08,p_new_sfs09)
DEFINE   p_item   LIKE  ima_file.ima01,
         p_sfs06  LIKE  sfs_file.sfs06,
         p_sqty   LIKE  rvbs_file.rvbs06,
         p_new_sfs07  LIKE sfs_file.sfs07,
         p_new_sfs08  LIKE sfs_file.sfs08,
         p_new_sfs09  LIKE sfs_file.sfs09,
         l_img09  LIKE  img_file.img09
DEFINE   l_n      LIKE  type_file.num5    #TQC-C20568 add

   IF cl_null(p_sqty)      THEN LET p_sqty      = 0   END IF
   IF cl_null(p_new_sfs07) THEN LET p_new_sfs07 = ' ' END IF
   IF cl_null(p_new_sfs08) THEN LET p_new_sfs08 = ' ' END IF
   IF cl_null(p_new_sfs09) THEN LET p_new_sfs09 = ' ' END IF
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01 = p_item
      AND img02 = p_new_sfs07
      AND img03 = p_new_sfs08
      AND img04 = p_new_sfs09

   LET g_argv_6 = p_item
   LET g_argv_7 = p_sfs06
   LET g_argv_8 = p_sqty
   LET g_argv_9 = l_img09
   LET g_argv_10 = p_new_sfs07
   LET g_argv_11 = p_new_sfs08
   LET g_argv_12 = p_new_sfs09
   OPEN WINDOW i501_mod_lot_w  WITH FORM "asf/42f/sasfi501_mod_lot" 
     ATTRIBUTE( STYLE = g_win_style ) 
   CALL cl_ui_locale("sasfi501_mod_lot")
   CALL i501_mod_lot_refresh_detail()
   CALL g_lot_rvbs.clear()

   SELECT COUNT(*) INTO l_n FROM rvbs_temp WHERE rvbs021 = g_argv_6  #TQC-C20568 add
   IF l_n = 0 THEN                                                  #TQC-C20568 add
      CALL i501_mod_lot_gen()  #TQC-C20509 add
   ELSE                                                             #TQC-C20568 add
      CALL i501_mod_lot_show()
   END IF                                                           #TQC-C20568 add
   CALL i501_mod_lot_menu()
   CLOSE WINDOW i501_mod_lot_w
   RETURN g_rvbs_srvbs06,g_rvbs_seqty   
END FUNCTION

FUNCTION i501_mod_lot_menu() 
  
   WHILE TRUE 
      CALL i501_mod_lot_bp("G") 
      CASE g_action_choice 
         WHEN "detail" 
            CALL i501_mod_lot_b() 
         WHEN "help" 
            CALL cl_show_help() 
         WHEN "exit" 
            LET INT_FLAG = 0 
            EXIT WHILE 
         WHEN "controlg" 
            CALL cl_cmdask() 
         WHEN "gen_data" 
            CALL i501_mod_lot_gen() 
      END CASE 
   END WHILE 
  
END FUNCTION  

FUNCTION i501_mod_lot_show()
   LET g_rvbs021     = g_argv_6
   LET g_rvbs_ounit  = g_argv_7
   LET g_rvbs_oqty   = g_argv_8
   LET g_rvbs_sunit  = g_argv_9

   CALL s_du_umfchk(g_argv_6,g_argv_10,g_argv_11,g_argv_12,g_rvbs_ounit,g_rvbs_sunit,'3')
      RETURNING g_errno,g_rvbs_fac
   LET g_rvbs_sqty   = g_rvbs_oqty*g_rvbs_fac    
   LET g_imgs02      = g_argv_10
   LET g_imgs03      = g_argv_11
   LET g_imgs04      = g_argv_12

   DISPLAY g_rvbs021,g_rvbs_ounit,g_rvbs_oqty,g_rvbs_sunit,g_rvbs_fac,g_rvbs_sqty
        TO rvbs021,FORMONLY.rvbs_ounit,FORMONLY.rvbs_oqty,FORMONLY.rvbs_sunit,
           FORMONLY.rvbs_fac,FORMONLY.rvbs_sqty
   SELECT ima02,ima021
     INTO g_rvbs_ima02,g_rvbs_ima021
     FROM ima_file
    WHERE ima01 = g_rvbs021
   DISPLAY g_rvbs_ima02,g_rvbs_ima021 TO FORMONLY.rvbs_ima02,FORMONLY.rvbs_ima021

   CALL i501_mod_lot_b_fill()
   #計算實際發料量合計和折合量合計
   SELECT SUM(rvbs06),SUM(rvbs_eqty) INTO g_rvbs_srvbs06,g_rvbs_seqty 
     FROM rvbs_temp 
    WHERE sel = 'Y'
      AND rvbs021 = g_rvbs021
   IF cl_null(g_rvbs_srvbs06) THEN LET g_rvbs_srvbs06 = 0 END IF
   IF cl_null(g_rvbs_seqty)   THEN LET g_rvbs_seqty   = 0 END IF
   DISPLAY g_rvbs_srvbs06,g_rvbs_seqty 
        TO FORMONLY.rvbs_srvbs06,FORMONLY.rvbs_seqty   
END FUNCTION

FUNCTION i501_mod_lot_b_fill()
DEFINE   l_sql    STRING
DEFINE l_j         LIKE type_file.num5
DEFINE l_inj04     LIKE inj_file.inj04 

   LET l_sql  = "SELECT sel,rvbs03,rvbs04,rvbs05,imgs08,rvbs07,rvbs08,",
                "       rvbs06,rvbs_eqty,'','','','','','','','','',''",
                "  FROM rvbs_temp",
                " WHERE rvbs021 ='",g_rvbs021,"'"
   PREPARE mod_lot_pre FROM l_sql
   DECLARE mod_lot_cs CURSOR FOR mod_lot_pre
   CALL g_lot_rvbs.clear()
   LET g_cnt = 1
   FOREACH  mod_lot_cs INTO g_lot_rvbs[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      FOR l_j = 1 TO g_imac.getLength()
          LET l_inj04 = NULL
          SELECT inj04 INTO l_inj04 FROM inj_file
           WHERE inj01 = g_rvbs021 AND inj02 = g_lot_rvbs[g_cnt].rvbs04
             AND inj03 = g_imac[l_j].imac04               
          CASE l_j
             WHEN 1
                LET g_lot_rvbs[g_cnt].att01 = l_inj04
             WHEN 2
                LET g_lot_rvbs[g_cnt].att02 = l_inj04
             WHEN 3
                LET g_lot_rvbs[g_cnt].att03 = l_inj04
             WHEN 4
                LET g_lot_rvbs[g_cnt].att04 = l_inj04
             WHEN 5
                LET g_lot_rvbs[g_cnt].att05 = l_inj04
             WHEN 6
                LET g_lot_rvbs[g_cnt].att06 = l_inj04
             WHEN 7
                LET g_lot_rvbs[g_cnt].att07 = l_inj04
             WHEN 8
                LET g_lot_rvbs[g_cnt].att08 = l_inj04
             WHEN 9
                LET g_lot_rvbs[g_cnt].att09 = l_inj04
             WHEN 10
                LET g_lot_rvbs[g_cnt].att10 = l_inj04
          END CASE
       END FOR
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_lot_rvbs.deleteElement(g_cnt)
   LET g_rec_b2  = g_cnt - 1
   LET g_cnt = 0
   CALL i501_mod_lot_refresh_detail()   
END FUNCTION 

FUNCTION i501_mod_lot_refresh_detail()
  DEFINE li_col_count                 LIKE type_file.num5 
  DEFINE li_i, li_j,li_cnt            LIKE type_file.num5
  DEFINE lc_index                     STRING
  DEFINE ls_sql                       STRING
  DEFINE ls_show,ls_hide              STRING
  DEFINE l_ini02                      LIKE ini_file.ini02

   #抓取製造批號層級料件特性資料
   LET li_cnt = 1
   DECLARE imac_cs CURSOR FOR 
           SELECT imac04 FROM imac_file 
            WHERE imac01 = g_argv_6
              AND imac03 = '2'
             ORDER BY imac02
   CALL g_imac.clear()   #TQC-C20506 add
   FOREACH imac_cs INTO g_imac[li_cnt].*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL g_imac.deleteElement(li_cnt)
   #依料件特性資料動態顯示隱藏欄位名稱及內容
  LET ls_show = ' '
  LET ls_hide = ' '
  FOR li_i = 1 TO g_imac.getLength()
     SELECT ini02 INTO l_ini02 FROM ini_file
      WHERE ini01 = g_imac[li_i].imac04
      LET lc_index = li_i USING '&&' 
      
     CALL cl_set_comp_att_text("att" || lc_index,l_ini02)
     IF li_i = 1 THEN
        LET  ls_show = ls_show || "att" || lc_index
     ELSE
        LET  ls_show = ls_show || ",att" || lc_index
     END IF
    
     CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
   END FOR
   FOR li_j = li_i TO 10
       LET lc_index = li_j USING '&&'
       IF li_j = li_i THEN
          LET ls_hide = ls_hide || "att" || lc_index
       ELSE
          LET ls_hide = ls_hide || ",att" || lc_index
       END IF
   END FOR 
   CALL cl_set_comp_visible(ls_hide,FALSE)
   CALL cl_set_comp_visible(ls_show,TRUE)
END FUNCTION

FUNCTION i501_mod_lot_bp(p_ud) 
   DEFINE p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN 
      RETURN 
   END IF 
  
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_lot_rvbs TO s_lot_rvbs.* ATTRIBUTE(COUNT=g_rec_b2) 
#TQC-C30067   ---begin---
      BEFORE DISPLAY 
         IF g_prog = 'asfi526' THEN
            CALL cl_set_act_visible('gen_data',FALSE)
         END IF 
#TQC-C30067  ---end---  
      BEFORE ROW 
         LET l_ac2 = ARR_CURR() 
         CALL cl_show_fld_cont()  
  
      ON ACTION detail 
         LET g_action_choice="detail" 
         LET l_ac2 = 1 
         EXIT DISPLAY 
  
      ON ACTION locale 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont() 
  
      ON ACTION help 
         LET g_action_choice="help" 
         EXIT DISPLAY 
  
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
         LET l_ac2 = ARR_CURR() 
         EXIT DISPLAY 
  
      ON ACTION cancel 
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE DISPLAY 
  
      AFTER DISPLAY 
         CONTINUE DISPLAY 
  
      ON ACTION controls 
         LET g_action_choice="controls" 
         EXIT DISPLAY 
  
      ON ACTION gen_data 
         LET g_action_choice="gen_data" 
         EXIT DISPLAY 
  
   END DISPLAY 
  
   CALL cl_set_act_visible("accept,cancel", TRUE) 
  
END FUNCTION

FUNCTION i501_mod_lot_b()
DEFINE
        l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
        l_n             LIKE type_file.num5,                #檢查重複用               
        l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
        p_cmd           LIKE type_file.chr1,                #處理狀態  
        l_allow_insert  LIKE type_file.num5,                #可新增否 
        l_allow_delete  LIKE type_file.num5                 #可刪除否
DEFINE  l_sum_qty       LIKE rvbs_file.rvbs06

   LET g_action_choice = ""
   IF s_shut(0) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')
   
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_lot_rvbs WITHOUT DEFAULTS FROM s_lot_rvbs.*
       ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED,                                           
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,           
                 APPEND ROW=l_allow_insert)                              
  
      BEFORE INPUT 
         IF g_rec_b != 0 THEN 
            CALL fgl_set_arr_curr(l_ac2) 
         END IF 

      BEFORE ROW 
         LET p_cmd = ''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK 
         IF g_rec_b2 >= l_ac2 THEN
            LET p_cmd = 'u'
            LET g_lot_rvbs_t.* = g_lot_rvbs[l_ac2].*
            CALL i501_mod_lot_entry_b()
         END IF 

      ON CHANGE sel
         #重新計算實際發料量合計和折合量合計
         CALL i501_mod_lot_cal()
         
      ON CHANGE rvbs06
         #重新計算實際發料量合計和折合量合計
         CALL i501_mod_lot_cal() 
         
      AFTER FIELD rvbs06
         IF NOT cl_null(g_lot_rvbs[l_ac2].rvbs06) THEN
            IF g_lot_rvbs[l_ac2].rvbs06 < 0 THEN 
               CALL cl_err('','art-040',0)
               LET g_lot_rvbs[l_ac2].rvbs06 = g_lot_rvbs_t.rvbs06
               DISPLAY BY NAME g_lot_rvbs[l_ac2].rvbs06
               NEXT FIELD rvbs06
            END IF 
            IF g_lot_rvbs[l_ac2].rvbs06 > g_lot_rvbs[l_ac2].imgs08 THEN  
               CALL cl_err(g_lot_rvbs[l_ac2].rvbs06,"axm-280",1)
               LET g_lot_rvbs[l_ac2].rvbs06 = g_lot_rvbs_t.rvbs06
               DISPLAY BY NAME g_lot_rvbs[l_ac2].rvbs06 
               NEXT FIELD rvbs06 
            END IF
         END IF

#att01~att10一旦進入就不能忽略
      AFTER FIELD att01
         IF cl_null(g_lot_rvbs[l_ac2].att01) THEN
            NEXT FIELD att01
         END IF
         
      AFTER FIELD att02
         IF cl_null(g_lot_rvbs[l_ac2].att02) THEN
            NEXT FIELD att02
         END IF

      AFTER FIELD att03
         IF cl_null(g_lot_rvbs[l_ac2].att03) THEN
            NEXT FIELD att03
         END IF

      AFTER FIELD att04
         IF cl_null(g_lot_rvbs[l_ac2].att04) THEN
            NEXT FIELD att04
         END IF

      AFTER FIELD att05
         IF cl_null(g_lot_rvbs[l_ac2].att05) THEN
            NEXT FIELD att05
         END IF

      AFTER FIELD att06
         IF cl_null(g_lot_rvbs[l_ac2].att06) THEN
            NEXT FIELD att06
         END IF

      AFTER FIELD att07
         IF cl_null(g_lot_rvbs[l_ac2].att07) THEN
            NEXT FIELD att07
         END IF

      AFTER FIELD att08
         IF cl_null(g_lot_rvbs[l_ac2].att08) THEN
            NEXT FIELD att08
         END IF

      AFTER FIELD att09
         IF cl_null(g_lot_rvbs[l_ac2].att09) THEN
            NEXT FIELD att09
         END IF

      AFTER FIELD att10
         IF cl_null(g_lot_rvbs[l_ac2].att10) THEN
            NEXT FIELD att10
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lot_rvbs[l_ac2].* = g_lot_rvbs_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         UPDATE rvbs_temp SET sel       = g_lot_rvbs[l_ac2].sel,
                              rvbs06    = g_lot_rvbs[l_ac2].rvbs06,
                              rvbs_eqty = g_lot_rvbs[l_ac2].rvbs_eqty
          WHERE rvbs021 = g_rvbs021
            AND rvbs03  = g_lot_rvbs_t.rvbs03
            AND rvbs04  = g_lot_rvbs_t.rvbs04
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd rvbs_temp',SQLCA.sqlcode,0)
            ROLLBACK WORK 
         END IF 
         #更新inj_file表數據
         IF  g_lot_rvbs[l_ac2].att01 <> g_lot_rvbs_t.att01 
             OR (cl_null(g_lot_rvbs_t.att01) AND NOT cl_null(g_lot_rvbs[l_ac2].att01)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att01
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[1].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att02 <> g_lot_rvbs_t.att02 
             OR (cl_null(g_lot_rvbs_t.att02) AND NOT cl_null(g_lot_rvbs[l_ac2].att02)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att02
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[2].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att03 <> g_lot_rvbs_t.att03 
             OR (cl_null(g_lot_rvbs_t.att03) AND NOT cl_null(g_lot_rvbs[l_ac2].att03)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att03
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[3].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att04 <> g_lot_rvbs_t.att04 
             OR (cl_null(g_lot_rvbs_t.att04) AND NOT cl_null(g_lot_rvbs[l_ac2].att04)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att04
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[4].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att05 <> g_lot_rvbs_t.att05 
             OR (cl_null(g_lot_rvbs_t.att05) AND NOT cl_null(g_lot_rvbs[l_ac2].att05)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att05
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[5].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att06 <> g_lot_rvbs_t.att06 
             OR (cl_null(g_lot_rvbs_t.att06) AND NOT cl_null(g_lot_rvbs[l_ac2].att06)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att06
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[6].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att07 <> g_lot_rvbs_t.att07
             OR (cl_null(g_lot_rvbs_t.att07) AND NOT cl_null(g_lot_rvbs[l_ac2].att07)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att07
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[7].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att08 <> g_lot_rvbs_t.att08
             OR (cl_null(g_lot_rvbs_t.att08) AND NOT cl_null(g_lot_rvbs[l_ac2].att08)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att08
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[8].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att09 <> g_lot_rvbs_t.att09 
             OR (cl_null(g_lot_rvbs_t.att09) AND NOT cl_null(g_lot_rvbs[l_ac2].att09)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att09
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[9].imac04
         END IF
         IF  g_lot_rvbs[l_ac2].att10 <> g_lot_rvbs_t.att10
             OR (cl_null(g_lot_rvbs_t.att10) AND NOT cl_null(g_lot_rvbs[l_ac2].att10)) THEN
               UPDATE inj_file SET inj04 = g_lot_rvbs[l_ac2].att10
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_lot_rvbs[l_ac2].rvbs04
                  AND inj03 = g_imac[10].imac04
         END IF         


      AFTER ROW
         LET l_ac2 = ARR_CURR()
         LET l_ac_t = l_ac2
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_lot_rvbs[l_ac2].* = g_lot_rvbs_t.*
            END IF
            ROLLBACK WORK 
            EXIT INPUT
         END IF
          #重新計算實際發料量合計和折合量合計
         CALL i501_mod_lot_cal()
         COMMIT WORK
         
      AFTER INPUT
         IF g_rvbs_seqty <> g_rvbs_sqty THEN 
            IF cl_confirm('asf1024') THEN 
               CONTINUE INPUT
            END IF             
         END IF 

      ON ACTION gen_data
         CALL i501_mod_lot_gen()

      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()  
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")    
   END INPUT
   COMMIT WORK
   
END FUNCTION

FUNCTION i501_mod_lot_entry_b()
DEFINE       l_j   LIKE   type_file.num5
DEFINE       l_inj06  LIKE inj_file.inj06
DEFINE       ls_entry,ls_noentry  STRING
DEFINE       lc_index  STRING
    LET ls_entry  = ' '
    LET ls_noentry = ' '
    FOR l_j = 1 TO g_imac.getLength() 
           SELECT inj06 INTO l_inj06 FROM inj_file
            WHERE inj01 = g_rvbs021 
              AND inj02 = g_lot_rvbs[l_ac2].rvbs04
              AND inj03 = g_imac[l_j].imac04
           LET lc_index = l_j USING '&&'
           IF l_j = 1 THEN
              IF l_inj06 = 'Y' THEN 
                 LET ls_noentry = ls_noentry || "att" || lc_index
              ELSE 
                 LET ls_entry   = ls_entry || "att" || lc_index
              END IF 
           ELSE
              IF l_inj06 = 'Y' THEN
                 LET ls_noentry = ls_noentry || ",att" || lc_index
              ELSE
                 LET ls_entry   = ls_entry || ",att" || lc_index
              END IF
           END IF
        END FOR 
    CALL cl_set_comp_entry(ls_noentry,FALSE)
    CALL cl_set_comp_entry(ls_entry,TRUE)
END FUNCTION  

FUNCTION i501_mod_lot_cal()
DEFINE   l_sum_rvbs06   LIKE rvbs_file.rvbs06,
         l_sum_eqty     LIKE rvbs_file.rvbs06
DEFINE   l_rvbs_eqty    LIKE rvbs_file.rvbs06
DEFINE   l_inj04        LIKE inj_file.inj04
DEFINE   i              LIKE type_file.num5    
   IF l_ac2 = 0  OR cl_null(l_ac2) THEN
      RETURN 
   END IF
   LET l_sum_rvbs06 = 0
   LET l_sum_eqty   = 0
   LET l_rvbs_eqty  = 0
   SELECT inj04 INTO l_inj04 FROM inj_file
    WHERE inj01 = g_rvbs021
      AND inj02 = g_lot_rvbs[l_ac2].rvbs04
      AND inj03 = "purity"
   IF cl_null(l_inj04) THEN LET l_inj04 = 100 END IF
      #单笔折合量
   LET  l_rvbs_eqty = g_lot_rvbs[l_ac2].rvbs06*l_inj04/100      #TQC-C20507 add '/100'
   LET  g_lot_rvbs[l_ac2].rvbs_eqty = l_rvbs_eqty

   FOR i = 1 TO g_lot_rvbs.getlength()
       IF g_lot_rvbs[i].sel="Y" THEN 
          LET l_sum_rvbs06 = l_sum_rvbs06 + g_lot_rvbs[i].rvbs06
          LET l_sum_eqty   = l_sum_eqty   + g_lot_rvbs[i].rvbs_eqty
       END IF
   END FOR
   LET g_rvbs_srvbs06 = l_sum_rvbs06
   LET g_rvbs_seqty   = l_sum_eqty
   DISPLAY g_rvbs_srvbs06,g_rvbs_seqty 
        TO FORMONLY.rvbs_srvbs06,FORMONLY.rvbs_seqty
   DISPLAY g_lot_rvbs[l_ac2].rvbs_eqty TO rvbs_eqty

END FUNCTION

FUNCTION i501_replace_b_sfs09_inschk(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_flag          LIKE type_file.chr1
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_count         LIKE type_file.num5
   DEFINE l_factor        LIKE img_file.img21
   DEFINE l_ima159        LIKE ima_file.ima159
   DEFINE l_img09         LIKE img_file.img09
   #控管是否為全型空白
   IF g_new_sfs[l_ac].sfs09 = '　' THEN #全型空白
       LET g_new_sfs[l_ac].sfs09 = ' '
   END IF
   IF g_new_sfs[l_ac].sfs09 IS NULL THEN LET g_new_sfs[l_ac].sfs09 =' ' END IF
   IF cl_null(g_new_sfs[l_ac].sfs09) AND NOT cl_null(g_new_sfs[l_ac].ima01) THEN
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_new_sfs[l_ac].ima01
      IF l_ima159 = '1' THEN
         CALL cl_err(g_new_sfs[l_ac].ima01,'aim-034',1)
         RETURN "sfs09"
      END IF
   END IF
&ifdef ICD
   IF g_argv1='2' AND NOT cl_null(g_new_sfs[l_ac].sfs04) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM sfe_file,sfp_file
       WHERE sfe02 = sfp01
         AND sfp06 IN ('1','2','3','4','A')
         AND sfp04 = 'Y'
         AND sfe01 = g_old_sfs03
         AND sfe07 = g_new_sfs[l_ac].ima01
      IF l_cnt >0 AND g_new_sfs[l_ac].sfs09 <> 'X' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM sfe_file,sfp_file
          WHERE sfe02 = sfp01
            AND sfp06 IN ('1','2','3','4','A')
            AND sfp04 = 'Y'
            AND sfe01 = g_old_sfs03
            AND sfe07 = g_new_sfs[l_ac].ima01
            AND sfe10 = g_new_sfs[l_ac].sfs09
         IF cl_null(l_cnt) OR l_cnt = 0 THEN
            CALL cl_err(g_new_sfs[l_ac].ima01,'aim-036',1)
            RETURN "sfs09"
         END IF
      END IF
   END IF
   #若已有idb存在不可修改
   IF g_sfp.sfp06 MATCHES '[12346789]' THEN 
      IF p_cmd = 'u' AND NOT cl_null(g_new_sfs[l_ac].sfs09) THEN
         IF g_new_sfs_t.sfs09 <> g_new_sfs[l_ac].sfs09 THEN
            CALL i501_replace_ind_icd_chk_icd()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_new_sfs[l_ac].sfs09 = g_new_sfs_t.sfs09
               RETURN "sfs09"
            END IF
         END IF
      END IF
   END IF
   IF NOT s_icdout_holdlot(g_new_sfs[l_ac].ima01,g_new_sfs[l_ac].sfs07,
                           g_new_sfs[l_ac].sfs08,g_new_sfs[l_ac].sfs09) THEN
      RETURN "sfs09"
   END IF
&endif
   SELECT img09,img10 INTO l_img09,g_new_sfs[l_ac].img10
     FROM img_file
    WHERE img01=g_new_sfs[l_ac].ima01 AND img02=g_new_sfs[l_ac].sfs07
      AND img03=g_new_sfs[l_ac].sfs08 AND img04=g_new_sfs[l_ac].sfs09
   IF g_argv1=1 AND STATUS THEN
      IF g_sma.sma93="Y" THEN 
         #再檢查該倉庫是否為VMI結算倉儲,若不是顯示錯誤訊息
         SELECT COUNT(*) INTO l_n FROM pmc_file
           WHERE pmc917=g_new_sfs[l_ac].sfs07   #VMI結算倉庫
           AND pmc918=g_new_sfs[l_ac].sfs08   #VMI結算儲位
         IF l_n = 0 THEN
            CALL cl_err('','asf-390',0)
            RETURN "sfs07"
         END IF
      ELSE                              #FUN-B80093 add
         CALL cl_err('','asf-390',0)    #FUN-B80093 add
         RETURN "sfs07"                 #FUN-B80093 add
      END IF                            #FUN-B80093 add
   END IF
   IF g_argv1=2 AND STATUS=100 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('mfg1401') THEN  RETURN "sfs09" END IF
      END IF
      CALL s_add_img(g_new_sfs[l_ac].ima01, g_new_sfs[l_ac].sfs07,
                     g_new_sfs[l_ac].sfs08, g_new_sfs[l_ac].sfs09,
                     g_sfp.sfp01,       g_new_sfs[l_ac].sfs02,
                     g_sfp.sfp02)
      IF g_errno='N' THEN RETURN "sfs09" END IF
      SELECT img09,img10 INTO l_img09,g_new_sfs[l_ac].img10
           FROM img_file
          WHERE img01=g_new_sfs[l_ac].ima01 AND img02=g_new_sfs[l_ac].sfs07
            AND img03=g_new_sfs[l_ac].sfs08 AND img04=g_new_sfs[l_ac].sfs09
   END IF
   IF g_sma.sma115 = 'N' THEN
      IF g_old_sfs06<>l_img09 THEN
         CALL s_umfchk(g_new_sfs[l_ac].ima01,g_old_sfs06,l_img09)
              RETURNING l_flag,l_factor
         IF l_flag THEN
            CALL cl_err('sfs06<>img09:','asf-400',0)
            RETURN "sfs09"
         END IF
      ELSE
         LET l_factor = 1
      END IF
   END IF

   DISPLAY BY NAME g_new_sfs[l_ac].img10
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01 = g_new_sfs[l_ac].ima01   #料號
         AND img02 = g_new_sfs[l_ac].sfs07   #倉庫
         AND img03 = g_new_sfs[l_ac].sfs08   #儲位
         AND img04 = g_new_sfs[l_ac].sfs09   #批號
         AND img18 < g_sfp.sfp03         #過帳日
      IF g_cnt > 0 THEN    #大於有效日期
         call cl_err('','aim-400',0)   #須修改
          RETURN "sfs07"
      END IF
   RETURN NULL
END FUNCTION

FUNCTION i501_replace_ind_icd_chk_icd()
    LET g_cnt = 0
    LET g_errno = ' '
    CASE WHEN g_sfp.sfp06 MATCHES '[1234]'   #發料 
              SELECT COUNT(*) INTO g_cnt FROM idb_file
                 WHERE idb07 = g_sfp.sfp01
                   AND idb08 = g_new_sfs_t.sfs02
         WHEN g_sfp.sfp06 MATCHES '[6789]'   #退料 
              SELECT COUNT(*) INTO g_cnt FROM ida_file
                 WHERE ida07 = g_sfp.sfp01
                   AND ida08 = g_new_sfs_t.sfs02
    END CASE
    IF g_cnt > 0 THEN
       LET g_errno = 'aic-113'
    ELSE
       LET g_errno = SQLCA.SQLCODE USING '-------'
    END IF
END FUNCTION


FUNCTION i501_mod_lot_gen()
   DEFINE l_wc   STRING
   DEFINE l_sql  STRING
   DEFINE l_ima925   LIKE ima_file.ima925
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022
   DEFINE l_imgs11   LIKE imgs_file.imgs11
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE lr_con     DYNAMIC ARRAY OF RECORD
             ini03   LIKE ini_file.ini03,
             oeba04  LIKE oeba_file.oeba04,
             oeba05  LIKE oeba_file.oeba05,
             oeba06  LIKE oeba_file.oeba06
   END RECORD
   DEFINE l_ogb31    LIKE ogb_file.ogb31,
          l_ogb32    LIKE ogb_file.ogb32,
          l_inj04    LIKE inj_file.inj04,
          l_inj04_1  LIKE inj_file.inj04,
          l_inj05    LIKE inj_file.inj05
   DEFINE l_con      LIKE type_file.num5,
          l_j        LIKE type_file.num5,
          l_char     LIKE inj_file.inj04,
          l_num      LIKE type_file.num10,
          l_n        LIKE type_file.num5
   DEFINE l_con_cnt  LIKE type_file.num5
   DEFINE ls_sql     STRING
   DEFINE l_exist    LIKE type_file.chr1

   LET g_rvbs021     = g_argv_6
   LET g_rvbs_ounit  = g_argv_7
   LET g_rvbs_oqty   = g_argv_8
   LET g_rvbs_sunit  = g_argv_9
   CALL s_du_umfchk(g_argv_6,g_argv_10,g_argv_11,g_argv_12,g_rvbs_ounit,g_rvbs_sunit,'3')
      RETURNING g_errno,g_rvbs_fac
   LET g_rvbs_sqty   = g_rvbs_oqty*g_rvbs_fac     
   LET g_imgs02      = g_argv_10
   LET g_imgs03      = g_argv_11
   LET g_imgs04      = g_argv_12

   IF g_imgs02 IS NULL THEN LET g_imgs02= ' ' END IF
   IF g_imgs03 IS NULL THEN LET g_imgs03= ' ' END IF
   IF g_imgs04 IS NULL THEN LET g_imgs04= ' ' END IF


   CLEAR FORM

   DISPLAY g_rvbs021,g_rvbs_ounit,g_rvbs_oqty,g_rvbs_sunit,g_rvbs_fac,g_rvbs_sqty
        TO rvbs021,FORMONLY.rvbs_ounit,FORMONLY.rvbs_oqty,FORMONLY.rvbs_sunit,
           FORMONLY.rvbs_fac,FORMONLY.rvbs_sqty
   SELECT ima02,ima021,ima925
     INTO g_rvbs_ima02,g_rvbs_ima021,l_ima925
     FROM ima_file
    WHERE ima01 = g_rvbs021
   DISPLAY g_rvbs_ima02,g_rvbs_ima021 TO FORMONLY.rvbs_ima02,FORMONLY.rvbs_ima021


   CONSTRUCT l_wc ON imgs05,imgs06,imgs09,imgs10,imgs11
                FROM s_lot_rvbs[1].rvbs03,s_lot_rvbs[1].rvbs04,s_lot_rvbs[1].rvbs05,
                     s_lot_rvbs[1].rvbs07,s_lot_rvbs[1].rvbs08

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   IF cl_null(l_imgs11) THEN
      LET l_imgs11 = " "
   END IF


   LET l_sql = "SELECT 'N',imgs05,imgs06,imgs09,imgs08,imgs10,imgs11,0,'',",
               "       '','','','','','','','','',''",
               "  FROM img_file,imgs_file",
               " WHERE img01 = imgs01",
               "   AND img02 = imgs02",
               "   AND img03 = imgs03",
               "   AND img04 = imgs04",
               "   AND imgs01 = '",g_rvbs021,"'",
               "   AND imgs02 = '",g_imgs02,"'",
               "   AND imgs03 = '",g_imgs03,"'",
               "   AND imgs04 = '",g_imgs04,"'",
               "   AND (imgs11 = ' ' OR imgs11 = '",l_imgs11,"')",
               "   AND ",l_wc,
               "   AND imgs08 > 0",
               "   AND img10 > 0"

   CASE l_ima925  #排序方式
      WHEN "1"   #序號
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs05"
      WHEN "2"   #製造批號

         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs06"
      WHEN "3"   #製造日期
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs09"
   END CASE

   PREPARE imgs_pre FROM l_sql
   DECLARE imgs_curs CURSOR FOR imgs_pre

   IF cl_null(g_rec_b2) OR g_rec_b2 = 0 THEN
      LET g_cnt = 1
   ELSE
      LET g_cnt = g_rec_b2 + 1
   END IF

   FOREACH imgs_curs INTO g_lot_rvbs[g_cnt].*              #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_exist = 'N'
         #抓取att01~att10特性資料
      FOR l_j = 1 TO g_imac.getLength()
         LET l_inj04 = NULL
#TQC-C20506 ----- mark ----- begin
#        SELECT COUNT(*),inj04 INTO l_n,l_inj04 FROM inj_file
#         WHERE inj01 = g_rvbs021 AND inj02 = g_lot_rvbs[g_cnt].rvbs04
#           AND inj03 = g_imac[l_j].imac04
#TQC-C20506 ----- mark ----- end
#TQC-C20506 ----- add ----- begin
         SELECT COUNT(*) INTO l_n FROM inj_file
          WHERE inj01 = g_rvbs021 AND inj02 = g_lot_rvbs[g_cnt].rvbs04
            AND inj03 = g_imac[l_j].imac04
#TQC-C20506 ----- add ----- end
         IF l_n = 0 THEN  #如果不存在特性資料則插入
            SELECT ima929 INTO l_inj05 FROM ima_file WHERE ima01 = g_rvbs021
            IF cl_null(l_inj05) THEN
               LET l_inj05 = g_rvbs021
            END IF
            INSERT INTO inj_file VALUES(g_rvbs021,g_lot_rvbs[g_cnt].rvbs04,
                                        g_imac[l_j].imac04,l_inj04,l_inj05,'N')
         END IF
#TQC-C20506 ----- add ----- begin
         SELECT inj04    INTO l_inj04 FROM inj_file
          WHERE inj01 = g_rvbs021 AND inj02 = g_lot_rvbs[g_cnt].rvbs04
            AND inj03 = g_imac[l_j].imac04
#TQC-C20506 ----- add ----- end
         CASE l_j
            WHEN 1
               LET g_lot_rvbs[g_cnt].att01 = l_inj04
            WHEN 2
               LET g_lot_rvbs[g_cnt].att02 = l_inj04
            WHEN 3
               LET g_lot_rvbs[g_cnt].att03 = l_inj04
            WHEN 4
               LET g_lot_rvbs[g_cnt].att04 = l_inj04
            WHEN 5
               LET g_lot_rvbs[g_cnt].att05 = l_inj04
            WHEN 6
               LET g_lot_rvbs[g_cnt].att06 = l_inj04
            WHEN 7
               LET g_lot_rvbs[g_cnt].att07 = l_inj04
            WHEN 8
               LET g_lot_rvbs[g_cnt].att08 = l_inj04
            WHEN 9
               LET g_lot_rvbs[g_cnt].att09 = l_inj04
            WHEN 10
               LET g_lot_rvbs[g_cnt].att10 = l_inj04
         END CASE
      END FOR
      #刪除已經存在的數據
      DELETE FROM rvbs_temp WHERE rvbs_temp.rvbs021 = g_rvbs021
                              AND rvbs_temp.rvbs03  = g_lot_rvbs[g_cnt].rvbs03
                              AND rvbs_temp.rvbs04  = g_lot_rvbs[g_cnt].rvbs04
      IF SQLCA.sqlcode THEN
         CALL cl_err3('del','rvbs_temp','','',SQLCA.sqlcode,'','',1)
      END IF
      IF SQLCA.sqlerrd[3] > 0 THEN
         LET l_exist = 'Y'
      END IF
      SELECT inj04 INTO l_inj04_1 FROM inj_file
       WHERE inj01 = g_rvbs021
         AND inj02 = g_lot_rvbs[g_cnt].rvbs04
         AND inj03 = "purity"
      IF cl_null(l_inj04_1) THEN LET l_inj04_1 = 100 END IF
           #单笔折合量
      LET g_lot_rvbs[g_cnt].rvbs_eqty = g_lot_rvbs[g_cnt].rvbs06*l_inj04_1/100     #TQC-C20507 add '/100'
            #寫入rvbs_temp
      INSERT INTO rvbs_temp VALUES(g_rvbs021,'N',g_lot_rvbs[g_cnt].rvbs03,
                                  g_lot_rvbs[g_cnt].rvbs04,g_lot_rvbs[g_cnt].rvbs05,
                                  g_lot_rvbs[g_cnt].imgs08,g_lot_rvbs[g_cnt].rvbs07,
                                  g_lot_rvbs[g_cnt].rvbs08,g_lot_rvbs[g_cnt].rvbs06,
                                  g_lot_rvbs[g_cnt].rvbs_eqty)
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','rvbs_temp','','',SQLCA.sqlcode,'','',1)
      END IF 
      IF l_exist='Y' THEN
         CALL g_lot_rvbs.deleteElement(g_cnt)
      ELSE
         LET g_cnt = g_cnt + 1
      END IF
   END FOREACH

   CALL g_lot_rvbs.deleteElement(g_cnt)

   LET g_rec_b2= g_cnt-1

   CALL i501_mod_lot_cal()

END FUNCTION
#TQC-C10054 ---add--end---
#DEV-D40013 add
