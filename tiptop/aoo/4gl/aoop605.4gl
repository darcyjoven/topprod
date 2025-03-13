# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aoop605.4gl
# Descriptions...: 基本上傳作業
# Date & Author..: 08/01/16 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/25 By Carrier 加入其他資料類型的上傳
# Modify.........: FUN-840081 08/04/18 By Carrier 開放資料中心的輸入
# Modify.........: NO.MOD-840283 08/04/20 BY Yiting 按x無法離開
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No.FUN-A90024 10/11/23 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global" #FUN-7C0010
 
DEFINE g_rec_b	  LIKE type_file.num10   #NO.MOD-840283
DEFINE g_gev01    LIKE gev_file.gev01
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_geu02    LIKE geu_file.geu02
DEFINE g_tables   DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  prog     LIKE zz_file.zz01,
                  gaz03    LIKE gaz_file.gaz03,
                  zr02     LIKE gat_file.gat01,
                  gat03    LIKE gat_file.gat03,
                  temptb   STRING                 #No.FUN-A80036
                  END RECORD
DEFINE g_table    DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  zr02     LIKE gat_file.gat01,
                  gat03    LIKE gat_file.gat03,
                  prog     LIKE zz_file.zz01,
                  gaz03    LIKE gaz_file.gaz03,
                  txt      LIKE ze_file.ze03
                  END RECORD
DEFINE g_sql        STRING       #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE g_msg      LIKE type_file.chr1000
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE l_ac       LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_db_type=cl_db_get_database_type()
 
   OPEN WINDOW p605_w WITH FORM "aoo/42f/aoop605"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL p605_tm1()
   CALL p605_tm()
 
   CLOSE WINDOW p605_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
 
FUNCTION p605_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_file         LIKE ze_file.ze03
  DEFINE l_prog         LIKE zz_file.zz01
  DEFINE l_tabname      LIKE gat_file.gat01
  DEFINE l_txt          LIKE ze_file.ze03
  DEFINE l_status       LIKE type_file.num5
 
    CALL g_table.clear()
    LET g_rec_b = 0
    WHILE TRUE
 
       CALL cl_set_act_visible("accept", FALSE)
       INPUT l_file WITHOUT DEFAULTS FROM FORMONLY.file
 
          ON CHANGE file
             LET l_file = GET_FLDBUF(file)
 
          AFTER FIELD file
             IF NOT cl_null(l_file) THEN
                CALL p605_check_file(l_file) RETURNING l_prog,l_tabname
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(l_file,g_errno,0)
                   NEXT FIELD file
                END IF
             END IF
 
          ON ACTION browse
             LET l_file = cl_browse_file()
             DISPLAY l_file TO FORMONLY.file
             CALL p605_check_file(l_file) RETURNING l_prog,l_tabname
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_file,g_errno,0)
             END IF
 
          ON ACTION add_body
             LET l_file = GET_FLDBUF(file)
             IF NOT cl_null(l_file) THEN
                CALL p605_check_file(l_file) RETURNING l_prog,l_tabname
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(l_file,g_errno,0)
                   NEXT FIELD file
                END IF
                CALL p605_upload(l_file) RETURNING l_status,l_txt
                IF l_status = 1 THEN
                   CALL p605_add_body(l_prog,l_tabname,l_txt)
                END IF
             END IF
 
          ON ACTION detail
             CALL p605_bp()
 
          ON ACTION upload
             IF g_rec_b > 0 THEN
                CALL p605_upload_file()
             END IF
 
          ON ACTION locale
             CALL cl_show_fld_cont()
             LET g_action_choice = "locale"
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT WHILE
 
          ON ACTION cancel
             LET INT_FLAG = 1
             EXIT WHILE
 
       END INPUT
       CALL cl_set_act_visible("accept", TRUE)
    END WHILE
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p605_w   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  
       EXIT PROGRAM
    END IF
 
END FUNCTION
 
 
FUNCTION p605_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)   #NO.FUN-840090                                                                              
   #CALL cl_set_act_visible("accept", FALSE)
   DISPLAY ARRAY g_table TO s_tables.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION delete
         CALL g_table.deleteElement(l_ac)
         LET g_rec_b = g_rec_b - 1
         CONTINUE DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
  CALL cl_set_act_visible("accept", TRUE)
END FUNCTION
 


FUNCTION p605_check_file(p_file)
  DEFINE p_file          LIKE ze_file.ze03
  DEFINE l_buf           base.StringBuffer
  DEFINE l_prog          LIKE zz_file.zz01
  DEFINE l_type          LIKE gev_file.gev01
  DEFINE l_tabname       LIKE gat_file.gat01
  DEFINE l_tabname1      LIKE gat_file.gat01
  DEFINE l_p1            LIKE type_file.num10
  DEFINE l_p2            LIKE type_file.num10
  DEFINE l_p3            LIKE type_file.num10
  DEFINE l_tabid         VARCHAR(30)
  DEFINE lst_token       base.StringTokenizer
  DEFINE ls_token        STRING
 
   LET g_errno = ''
 
   LET lst_token = base.StringTokenizer.create(p_file,'/')
 
   WHILE lst_token.hasMoreTokens()
      LET ls_token = lst_token.nextToken()
   END WHILE
 
   LET l_buf = base.StringBuffer.create()
   LET p_file = ls_token
   CALL l_buf.append(p_file)
   LET l_p1 = l_buf.getIndexOf("_", 1)
   #check delimeter
   IF l_p1 = 0 THEN
      LET g_errno = 'aoo-039'
      RETURN NULL,NULL
   END IF
   IF l_p1 = 1 THEN
      LET g_errno = 'aoo-039'
      RETURN NULL,NULL
   END IF
   LET l_prog = p_file[1,l_p1-1]
   IF cl_null(l_prog) THEN
      LET g_errno = 'aoo-040'
      RETURN NULL,NULL
   END IF
 
   LET l_p3 = l_buf.getIndexOf("_", l_p1+1)
   LET l_p3 = l_buf.getIndexOf("_", l_p3+1)  #aooi030_gem_file_0.txt
   IF l_p3 = 0 THEN
      LET g_errno = 'aoo-095'
      RETURN NULL,NULL
   END IF
   LET l_type = p_file[l_p3+1,l_p3+1]
   IF cl_null(l_type) THEN
      LET g_errno = 'aoo-095'
      RETURN NULL,NULL
   END IF
   IF g_gev01 <> l_type THEN
      LET g_errno = 'aoo-095'
      RETURN NULL,NULL
   END IF
   LET l_p2 = l_buf.getIndexOf(".", 1)
   IF l_p2 = 0 THEN
      LET g_errno = 'aoo-039'
      RETURN NULL,NULL
   END IF
   LET l_tabname = p_file[l_p1+1,l_p3-1]
   IF cl_null(l_tabname) THEN
      LET g_errno = 'aoo-041'
      RETURN NULL,NULL
   END IF
   LET l_tabname1 = DOWNSHIFT(l_tabname)
   LET l_tabname = l_tabname1
   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #CASE g_db_type 
   #   WHEN 'IFX' 
   #      SELECT tabid INTO l_tabid FROM systables
   #       WHERE tabname=l_tabname
   #   WHEN 'ORA' 
   #      SELECT OBJECT_NAME INTO l_tabid FROM user_objects
   #       WHERE LOWER(object_name)=l_tabname
   #   WHEN 'MSV'
   #      SELECT name INTO l_tabid FROM sys.tables
   #       WHERE name=l_tabname
   #   WHEN 'ASE'    
   #      SELECT name INTO l_tabid FROM sys.tables
   #       WHERE name=l_tabname
   #END CASE
   SELECT DISTINCT sch01 INTO l_tabid FROM sch_file 
     WHERE sch01 = l_tabname
   #---FUN-A90024---end-------  

   IF SQLCA.sqlcode THEN
      LET g_errno = 'aoo-042'
      RETURN NULL,NULL
   END IF
 
   RETURN l_prog,l_tabname
 
END FUNCTION
 
FUNCTION p605_upload(p_file)
  DEFINE p_file            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_n               LIKE type_file.num5
  DEFINE lst_token         base.StringTokenizer
  DEFINE ls_token          STRING
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
 
   LET lst_token = base.StringTokenizer.create(p_file,'/')
 
   WHILE lst_token.hasMoreTokens()
      LET ls_token = lst_token.nextToken()
   END WHILE
 
   LET l_download_file = l_tempdir CLIPPED,'/',ls_token.trim()
   LET l_upload_file = p_file
   CALL cl_upload_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      RETURN 1,l_download_file
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN 0,l_download_file
   END IF
 
END FUNCTION
 
FUNCTION p605_add_body(p_prog,p_tabname,p_txt)
  DEFINE p_prog        LIKE zz_file.zz01
  DEFINE p_tabname     LIKE gat_file.gat01
  DEFINE p_txt         LIKE ze_file.ze03
 
    LET g_rec_b = g_rec_b + 1
    LET g_table[g_rec_b].prog = p_prog
    LET g_table[g_rec_b].zr02 = p_tabname
    LET g_table[g_rec_b].txt  = p_txt
 
    SELECT gaz03 INTO g_table[g_rec_b].gaz03 FROM gaz_file
     WHERE gaz01 = g_table[g_rec_b].prog
       AND gaz02 = g_lang
       AND gaz05 = 'N'
    SELECT gat03 INTO g_table[g_rec_b].gat03 FROM gat_file
     WHERE gat01 = g_table[g_rec_b].zr02
       AND gat02 = g_lang
 
    DISPLAY ARRAY g_table TO s_tables.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
 
#No.FUN-830090  --Begin
FUNCTION p605_upload_file()
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_j               LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_temp_file       LIKE ze_file.ze03
  DEFINE l_temp_file1      LIKE ze_file.ze03
  DEFINE l_gev04           LIKE gev_file.gev04
  DEFINE l_tabname         LIKE type_file.chr50
  DEFINE l_ima             DYNAMIC ARRAY OF RECORD 
                           sel      LIKE type_file.chr1, 
                           ima01    LIKE ima_file.ima01 
                           END RECORD
  DEFINE l_bma             DYNAMIC ARRAY OF RECORD                           
                           sel      LIKE type_file.chr1,                     
                           bma01    LIKE bma_file.bma01,                     
                           bma06    LIKE bma_file.bma06                      
                           END RECORD
  DEFINE l_bmx             DYNAMIC ARRAY OF RECORD
                           sel      LIKE type_file.chr1,
                           bmx01    LIKE bmx_file.bmx01
                           END RECORD
  DEFINE l_occ             DYNAMIC ARRAY OF RECORD
                           sel      LIKE type_file.chr1,
                           occ01    LIKE occ_file.occ01
                           END RECORD
  DEFINE l_pmc             DYNAMIC ARRAY OF RECORD 
                           sel      LIKE type_file.chr1,
                           pmc01    LIKE pmc_file.pmc01
                           END RECORD             
  DEFINE l_aag             DYNAMIC ARRAY OF RECORD
                           sel      LIKE type_file.chr1,
                           aag00    LIKE aag_file.aag00,
                           aag01    LIKE aag_file.aag01
                           END RECORD
  DEFINE l_giu             DYNAMIC ARRAY OF RECORD
                           giu00    LIKE giu_file.giu00,
                           giu01    LIKE giu_file.giu01,
                           sel      LIKE type_file.chr1 
                           END RECORD
  DEFINE l_tqm             DYNAMIC ARRAY OF RECORD
                           sel      LIKE type_file.chr1,
                           tqm01    LIKE tqm_file.tqm01
                           END RECORD
 
   #upload db
   CALL g_azp.clear()
   LET g_azp[1].sel   = 'Y'
   LET g_azp[1].azp01 = g_plant
   SELECT azp02 INTO g_azp[1].azp02 FROM azp_file
    WHERE azp01 = g_plant
   LET g_azp[1].azp03 = g_dbs
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')
   LET l_temp_file  = l_tempdir CLIPPED,'/create_table.sql'
   LET l_temp_file1 = l_tempdir CLIPPED,'/create_table.tmp'
 
   #basic data
   IF g_gev01 = '0' THEN
      CALL g_tables.clear()
      FOR l_i =1 TO g_rec_b
          LET g_tables[l_i].sel   = 'Y'
          LET g_tables[l_i].prog  = g_table[l_i].prog
          LET g_tables[l_i].gaz03 = g_table[l_i].gaz03
          LET g_tables[l_i].zr02  = g_table[l_i].zr02
          LET g_tables[l_i].gat03 = g_table[l_i].gat03
 
          CALL s_dc_cre_temp_table(g_table[l_i].zr02) RETURNING l_tabname 
          LET g_tables[l_i].temptb= l_tabname         #No.FUN-A80036
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL s_showmsg_init()
      CALL s_basic_data_carry(g_tables,g_azp,g_gev04,'2')
      CALL s_showmsg()
  
      FOR l_i =1 TO g_rec_b
          #No.FUN-A80036  --Begin                                               
          #LET l_tabname = g_table[l_i].zr02 CLIPPED,"_bak"                     
          LET l_tabname = g_tables[l_i].temptb                                  
          #No.FUN-A80036  --End
          CALL s_dc_drop_temp_table(l_tabname)
      END FOR
   END IF
   #basic data
   IF g_gev01 = '1' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'ima_file' THEN
             CALL s_dc_cre_temp_table1('ima_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'imc_file' THEN
             CALL s_dc_cre_temp_table1('imc_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'smd_file' THEN
             CALL s_dc_cre_temp_table1('smd_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'imaicd_file' THEN
             CALL s_dc_cre_temp_table1('imaicd_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_ima.clear()
      CALL s_showmsg_init()
      CALL s_aimi100_carry(l_ima,g_azp,g_gev04,'1')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('ima_file_bak1')
      CALL s_dc_drop_temp_table('imc_file_bak1')
      CALL s_dc_drop_temp_table('smd_file_bak1')
      CALL s_dc_drop_temp_table('imaicd_file_bak1')
   END IF
   
   #bom data
   IF g_gev01 = '2' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'bma_file' THEN
             CALL s_dc_cre_temp_table1('bma_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmc_file' THEN
             CALL s_dc_cre_temp_table1('bmc_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmb_file' THEN
             CALL s_dc_cre_temp_table1('bmb_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmd_file' THEN
             CALL s_dc_cre_temp_table1('bmd_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmt_file' THEN
             CALL s_dc_cre_temp_table1('bmt_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bml_file' THEN
             CALL s_dc_cre_temp_table1('bml_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bob_file' THEN
             CALL s_dc_cre_temp_table1('bob_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'boa_file' THEN
             CALL s_dc_cre_temp_table1('boa_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_bma.clear()
      CALL s_showmsg_init()
      CALL s_abmi600_carry(l_bma,g_azp,g_gev04,'1')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('bma_file_bak1')
      CALL s_dc_drop_temp_table('bmb_file_bak1')
      CALL s_dc_drop_temp_table('bmc_file_bak1')
      CALL s_dc_drop_temp_table('bmd_file_bak1')
      CALL s_dc_drop_temp_table('bmt_file_bak1')
      CALL s_dc_drop_temp_table('bml_file_bak1')
      CALL s_dc_drop_temp_table('bob_file_bak1')
      CALL s_dc_drop_temp_table('boa_file_bak1')
   END IF
   #ECN
   IF g_gev01 = '3' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'bmx_file' THEN
             CALL s_dc_cre_temp_table1('bmx_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmz_file' THEN
             CALL s_dc_cre_temp_table1('bmz_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmy_file' THEN
             CALL s_dc_cre_temp_table1('bmy_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmf_file' THEN
             CALL s_dc_cre_temp_table1('bmf_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmg_file' THEN
             CALL s_dc_cre_temp_table1('bmg_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'bmw_file' THEN
             CALL s_dc_cre_temp_table1('bmw_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_bmx.clear()
      CALL s_showmsg_init()
      CALL s_abmi710_carry_bmx(l_bmx,g_azp,g_gev04,'1')
#     CALL s_abmi710_carry_bmx(l_bmx,g_azp,g_gev04,'')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('bmx_file_bak1')
      CALL s_dc_drop_temp_table('bmz_file_bak1')
      CALL s_dc_drop_temp_table('bmy_file_bak1')
      CALL s_dc_drop_temp_table('bmf_file_bak1')
      CALL s_dc_drop_temp_table('bmg_file_bak1')
      CALL s_dc_drop_temp_table('bmw_file_bak1')
   END IF
 
   #customer data
   IF g_gev01 = '4' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'occ_file' THEN
             CALL s_dc_cre_temp_table1('occ_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'occg_file' THEN
             CALL s_dc_cre_temp_table1('occg_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'ocd_file' THEN
             CALL s_dc_cre_temp_table1('ocd_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'oce_file' THEN
             CALL s_dc_cre_temp_table1('oce_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'oci_file' THEN
             CALL s_dc_cre_temp_table1('oci_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'ocj_file' THEN
             CALL s_dc_cre_temp_table1('ocj_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tql_file' THEN
             CALL s_dc_cre_temp_table1('tql_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tqk_file' THEN
             CALL s_dc_cre_temp_table1('tqk_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tqo_file' THEN
             CALL s_dc_cre_temp_table1('tqo_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tqm_file' THEN
             CALL s_dc_cre_temp_table1('tqm_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tqn_file' THEN
             CALL s_dc_cre_temp_table1('tqn_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pov_file' THEN
             CALL s_dc_cre_temp_table1('pov_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_occ.clear()
      CALL s_showmsg_init()
      CALL s_axmi221_carry_occ(l_occ,g_azp,g_gev04,'1','1')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('occ_file_bak1')
      CALL s_dc_drop_temp_table('occg_file_bak1')
      CALL s_dc_drop_temp_table('ocd_file_bak1')
      CALL s_dc_drop_temp_table('oce_file_bak1')
      CALL s_dc_drop_temp_table('oci_file_bak1')
      CALL s_dc_drop_temp_table('ocj_file_bak1')
      CALL s_dc_drop_temp_table('tql_file_bak1')
      CALL s_dc_drop_temp_table('tqk_file_bak1')
      CALL s_dc_drop_temp_table('tqo_file_bak1')
      CALL s_dc_drop_temp_table('tqm_file_bak1')
      CALL s_dc_drop_temp_table('tqn_file_bak1')
      CALL s_dc_drop_temp_table('pov_file_bak1')
   END IF
 
   #vender data
   IF g_gev01 = '5' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'pmc_file' THEN
             CALL s_dc_cre_temp_table1('pmc_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pnp_file' THEN
             CALL s_dc_cre_temp_table1('pnp_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pmf_file' THEN
             CALL s_dc_cre_temp_table1('pmf_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pmd_file' THEN
             CALL s_dc_cre_temp_table1('pmd_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pov_file' THEN
             CALL s_dc_cre_temp_table1('pov_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'pmg_file' THEN
             CALL s_dc_cre_temp_table1('pmg_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_pmc.clear()
      CALL s_showmsg_init()
      CALL s_apmi600_carry_pmc(l_pmc,g_azp,g_gev04,'1')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('pmc_file_bak1')
      CALL s_dc_drop_temp_table('pnp_file_bak1')
      CALL s_dc_drop_temp_table('pmf_file_bak1')
      CALL s_dc_drop_temp_table('pmd_file_bak1')
      CALL s_dc_drop_temp_table('pov_file_bak1')
      CALL s_dc_drop_temp_table('pmg_file_bak1')
   END IF
 
   #account data
   IF g_gev01 = '6' THEN
      #No.FUN-A80036  --Begin
      #FOR l_i =1 TO g_rec_b
      #    IF g_table[l_i].zr02 = 'aag_file' THEN
      #       CALL s_dc_cre_temp_table1('aag_file') RETURNING l_tabname           
      #    END IF
      #    LET g_sql = " INSERT INTO ",l_tabname
      #    LOAD FROM g_table[l_i].txt g_sql
      #END FOR
      #No.FUN-A80036  --End  
 
      FOR l_i = 1 TO g_rec_b
          IF g_table[l_i].zr02 = 'aag_file' THEN
             CALL s_dc_cre_temp_table1('aag_file') RETURNING l_tabname           
             #No.FUN-A80036  --Begin                                               
             IF cl_null(l_tabname) THEN RETURN END IF                              
             #No.FUN-A80036  --End
             LET g_sql = " INSERT INTO ",l_tabname
             LOAD FROM g_table[l_i].txt g_sql
             #carry data generate from txt,not formal table
             CALL l_aag.clear()
             CALL s_showmsg_init()
             CALL s_agli102_carry_aag(l_aag,g_azp,g_gev04,'1')
             CALL s_showmsg()
             CALL s_dc_drop_temp_table('aag_file_bak1')
          END IF
          IF g_table[l_i].zr02 = 'giu_file' THEN
             CALL s_dc_cre_temp_table1('giu_file') RETURNING l_tabname           
             #No.FUN-A80036  --Begin                                               
             IF cl_null(l_tabname) THEN RETURN END IF                              
             #No.FUN-A80036  --End
             LET g_sql = " INSERT INTO ",l_tabname
             LOAD FROM g_table[l_i].txt g_sql
             #carry data generate from txt,not formal table
             CALL l_giu.clear()
             CALL s_showmsg_init()
             CALL s_agli010_carry_giu(l_giu,g_azp,g_gev04,'1')
             CALL s_showmsg()
             CALL s_dc_drop_temp_table('giu_file_bak1')
          END IF
      END FOR
  
   END IF
 
   #price data
   IF g_gev01 = '7' THEN
      FOR l_i =1 TO g_rec_b
          IF g_table[l_i].zr02 = 'tqm_file' THEN
             CALL s_dc_cre_temp_table1('tqm_file') RETURNING l_tabname           
          END IF
          IF g_table[l_i].zr02 = 'tqn_file' THEN
             CALL s_dc_cre_temp_table1('tqn_file') RETURNING l_tabname           
          END IF
          #No.FUN-A80036  --Begin                                               
          IF cl_null(l_tabname) THEN RETURN END IF                              
          #No.FUN-A80036  --End
          LET g_sql = " INSERT INTO ",l_tabname
          LOAD FROM g_table[l_i].txt g_sql
      END FOR
 
      #carry data generate from txt,not formal table
      CALL l_tqm.clear()
      CALL s_showmsg_init()
      CALL s_atmp227_carry_tqm(l_tqm,g_azp,g_gev04,'','1')
      CALL s_showmsg()
  
      CALL s_dc_drop_temp_table('tqm_file_bak1')
      CALL s_dc_drop_temp_table('tqn_file_bak1')
   END IF
 
 
 
   LET g_sql = " rm ",l_temp_file
   RUN g_sql
   LET g_sql = " rm ",l_temp_file1
   RUN g_sql
 
END FUNCTION
#No.FUN-830090  --End
 
FUNCTION p605_tm1()
  DEFINE l_sql,l_where  STRING
  DEFINE l_file         LIKE ze_file.ze03
  DEFINE l_prog         LIKE zz_file.zz01
  DEFINE l_tabname      LIKE gat_file.gat01
  DEFINE l_txt          LIKE ze_file.ze03
  DEFINE l_status       LIKE type_file.num5
 
    INPUT g_gev01,g_gev04 WITHOUT DEFAULTS FROM gev01,gev04  #No.FUN-840081
 
       #No.FUN-840081  --Begin
       AFTER FIELD gev01
          IF cl_null(g_gev01) THEN
             NEXT FIELD gev01
          END IF
 
       AFTER FIELD gev04
          IF NOT cl_null(g_gev04) THEN
             CALL p605_gev04(g_gev04,g_gev01)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gev04,g_errno,0)
                NEXT FIELD gev04
             END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(gev04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gew01"
                LET g_qryparam.arg1 = g_gev01
                LET g_qryparam.arg2 = g_plant
                CALL cl_create_qry() RETURNING g_gev04
                DISPLAY g_gev04 TO gev04
                CALL p605_gev04(g_gev04,g_gev01)
                NEXT FIELD gev04
             OTHERWISE EXIT CASE
          END CASE
       #No.FUN-840081  --End
 
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT INPUT
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p605_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
 
    #LET g_gev04=NULL
    #LET g_geu02=NULL
 
    #SELECT gev04 INTO g_gev04 FROM gev_file
    # WHERE gev01 = g_gev01 AND gev02 = g_plant
    #SELECT geu02 INTO g_geu02 FROM geu_file
    # WHERE geu01 = g_gev04
    #DISPLAY g_gev04 TO gev04
    #DISPLAY g_geu02 TO geu02
 
END FUNCTION
 
FUNCTION p605_gev04(p_gev04,p_gew02)
  DEFINE p_gev04    LIKE gev_file.gev04
  DEFINE p_gew02    LIKE gew_file.gew02
  DEFINE l_geu00    LIKE geu_file.geu00
  DEFINE l_geu02    LIKE geu_file.geu02
  DEFINE l_geuacti  LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
      FROM geu_file WHERE geu01=p_gev04
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    ELSE
      SELECT * FROM gew_file
       WHERE gew01 = p_gev04 
         AND gew02 = p_gew02
         AND gew04 = g_plant
      IF SQLCA.sqlcode THEN
         LET g_errno = 'aoo-034'   #gev_file沒有維護,不能拋轉
      END IF
 
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    END IF
    DISPLAY l_geu02 TO geu02
END FUNCTION
