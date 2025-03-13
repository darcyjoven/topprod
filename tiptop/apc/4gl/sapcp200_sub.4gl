# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: sapcp200_sub.4gl
# Descriptions...: POS上傳資料確認過帳使用
# Date & Author..: No.FUN-C50090 12/05/24 By baogc
# Modify.........: No:FUN-C80068 12/08/17 By baogc CALL s_mupimg 參數修改
# Modify.........: No:FUN-C80079 12/08/23 By baogc 銷退單更新出貨單時,不更新ogb64(財務要求)
# Modify.........: No:FUN-C90011 12/09/05 By baogc 訂單轉請購修改
# Modify.........: No:FUN-C80107 12/09/19 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-C90065 12/09/26 By baogc 增加WHENEVER ERROR CONTINUE
# Modify.........: No:FUN-CA0091 12/10/14 By baogc 效能調整
# Modify.........: No:FUN-CB0103 12/11/28 By baogc 邏輯調整
# Modify.........: No:FUN-CC0082 12/12/14 By baogc 異店取貨邏輯
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global"

DEFINE g_pml RECORD LIKE pml_file.*
DEFINE g_pmn RECORD LIKE pmn_file.*
DEFINE g_oeb03      LIKE oeb_file.oeb03
DEFINE g_fno        LIKE oga_file.oga16
DEFINE g_sql        STRING
DEFINE g_plant_sub  LIKE azw_file.azw01
DEFINE g_legal_sub  LIKE azw_file.azw02
DEFINE g_oga        RECORD LIKE oga_file.*
DEFINE g_ogb        RECORD LIKE ogb_file.*
DEFINE g_oha        RECORD LIKE oha_file.*
DEFINE g_ohb        RECORD LIKE ohb_file.*
DEFINE g_ima906     LIKE ima_file.ima906
DEFINE g_ima25      LIKE ima_file.ima25
DEFINE g_ima86      LIKE ima_file.ima86
DEFINE g_forupd_sql STRING
DEFINE g_rvu04      LIKE rvu_file.rvu04
DEFINE g_alter_date LIKE type_file.dat
DEFINE g_azw01      LIKE azw_file.azw01
DEFINE g_azw02      LIKE azw_file.azw02
DEFINE g_rvc        RECORD LIKE rvc_file.*
DEFINE g_rvv39t     LIKE rvv_file.rvv39t
DEFINE g_rvf08      LIKE rvf_file.rvf08
DEFINE g_ima918     LIKE ima_file.ima918
DEFINE g_ima921     LIKE ima_file.ima921
DEFINE b_ohb        RECORD  LIKE ohb_file.*
DEFINE l_oga        RECORD  LIKE oga_file.*
DEFINE l_ohb12      LIKE ohb_file.ohb12
DEFINE l_ogb12      LIKE ogb_file.ogb12
DEFINE l_ogb14t     LIKE ogb_file.ogb14t
DEFINE l_ogb14      LIKE ogb_file.ogb14
DEFINE l_ohb14      LIKE ohb_file.ohb14
DEFINE l_ohb14t     LIKE ohb_file.ohb14t
DEFINE l_msg1       LIKE type_file.chr1000
DEFINE l_msg2       LIKE type_file.chr1000
DEFINE l_msg3       LIKE type_file.chr1000
DEFINE g_ima907     LIKE ima_file.ima907
DEFINE tot1         LIKE ohb_file.ohb12
DEFINE tot2         LIKE ohb_file.ohb12
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_chr        LIKE type_file.chr1
DEFINE g_argv0      LIKE type_file.chr1
DEFINE g_plant_ord  LIKE azw_file.azw01  #FUN-CC0082 Add

#Note:原sapcp200_oea.4gl
#訂單確認過帳
FUNCTION t400sub_y_chk(p_flag,p_oea01,p_plant,p_fno)
DEFINE p_oea01    LIKE oea_file.oea01
DEFINE p_fno      LIKE oga_file.oga16
DEFINE p_plant    LIKE azw_file.azw01
DEFINE p_flag     LIKE type_file.chr1
DEFINE l_oea      RECORD LIKE oea_file.*
DEFINE l_oeb      RECORD LIKE oeb_file.*
DEFINE l_oeb14t   LIKE oeb_file.oeb14t
DEFINE l_oeb14    LIKE oeb_file.oeb14
DEFINE l_oeb14t_1 LIKE oeb_file.oeb14t
DEFINE l_price    LIKE oeb_file.oeb14t
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_msg,l_msg1,l_msg2  STRING
 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤
      
  LET g_fno = p_fno
  LET g_plant_sub =p_plant
  LET g_plant_new = p_plant
  CALL s_gettrandbs()
  LET g_dbs=g_dbs_tra
  CALL s_getlegal(g_plant_sub) RETURNING g_legal_sub
  LET g_success = 'Y'
  IF cl_null(p_oea01) THEN
     LET g_msg  = g_plant_new,"/",g_fno,"/",p_oea01
     CALL s_errmsg('azw01,oea94,oea01',g_msg,' oea_confirm(chk oea01):','-400',1)
     LET g_success = 'N'
     ROLLBACK WORK
     LET g_errno = '-400'
     LET g_msg1=' '||' '||g_plant_new||g_fno
     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
     LET g_msg=g_msg[1,255]
     CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
     LET g_errno=''
     LET g_msg=''
     LET g_msg1=''
     RETURN
  END IF
  LET g_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'),
            " WHERE oea01 ='", p_oea01,"'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  PREPARE sel_oea_pre FROM g_sql
  EXECUTE sel_oea_pre INTO l_oea.*

  IF l_oea.oea00 != "2" AND cl_null(l_oea.oea32)  THEN
     LET g_msg  = g_plant_new,"/",g_fno
     LET g_msg1 = " oea_confirm(chk oea32):Recive Term is null"
     CALL s_errmsg('azw01,oea94',g_msg,g_msg1,'axm-317',1)
     LET g_success = 'N'
     ROLLBACK WORK
     LET g_errno = 'axm-317'
     LET g_msg1=' '||' '||g_plant_new||g_fno
     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
     LET g_msg=g_msg[1,255]
     CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
     LET g_errno=''
     LET g_msg=''
     LET g_msg1=''
     RETURN
  END IF
 
  IF g_azw.azw04='2' THEN
     LET g_sql = "SELECT SUM(oeb14t) FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
                 " WHERE oeb01='",l_oea.oea01,"' AND oeb70='N'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE sel_oeb14t_pre FROM g_sql
     EXECUTE sel_oeb14t_pre INTO l_oeb14t_1  
     IF SQLCA.sqlcode=100 THEN LET l_oeb14t_1=NULL END IF
     IF cl_null(l_oeb14t_1) THEN LET l_oeb14t_1=0 END IF

     LET g_sql="SELECT azi04 FROM ",g_dbs,"azi_file", 
               " WHERE azi01='",l_oea.oea23,"'"
     PREPARE sel_azi04_pre FROM g_sql
     EXECUTE sel_azi04_pre INTO t_azi04
     LET l_price = (l_oeb14t_1)*l_oea.oea161/100                    
     CALL cl_digcut(l_price,t_azi04) RETURNING l_price

     LET g_sql="SELECT SUM(rxx04) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), 
               " WHERE rxx00='01' AND rxx01='",l_oea.oea01,"'", 
               "   AND rxx03='1' AND rxxplant='",l_oea.oeaplant,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
     PREPARE sel_rxx04_pre FROM g_sql
     EXECUTE sel_rxx04_pre INTO l_rxx04

     IF SQLCA.sqlcode THEN 
        CALL cl_err('sel sum(rxx04)',status,0)
        LET l_rxx04=NULL 
     END IF
     IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF         
     IF l_rxx04<l_price THEN 
        LET g_msg  = g_plant_new,"/",g_fno
        LET g_msg1 = " oea_confirm(chk rxx04):"
        CALL s_errmsg('azw01,oea94',g_msg,g_msg1,'art-265',1)
        LET g_success='N'
        ROLLBACK WORK
        LET g_errno = 'art-265'
        LET g_msg1=' '||' '||g_plant_new||g_fno
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
        LET g_msg=g_msg[1,255]
        CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
        LET g_errno=''
        LET g_msg=''
        LET g_msg1=''
        RETURN
     END IF 
  END IF
    
END FUNCTION

FUNCTION t400sub_lock_cl()
DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'occ_file'),
                      " WHERE occ01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql              
   CALL cl_parse_qry_sql(l_forupd_sql,g_plant_new) RETURNING l_forupd_sql 
   DECLARE t400sub_cl2 CURSOR FROM l_forupd_sql
END FUNCTION

FUNCTION t400sub_y_upd(p_oea01,p_action_choice,p_plant,p_fno)
DEFINE p_oea01         LIKE oea_file.oea01
DEFINE p_plant         LIKE azw_file.azw01
DEFINE l_oea           RECORD LIKE oea_file.*
DEFINE p_action_choice STRING
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_cmd           LIKE type_file.chr1000
DEFINE l_wc            LIKE type_file.chr1000
DEFINE l_msg           LIKE type_file.chr1000
DEFINE l_oeamksg       LIKE oea_file.oeamksg
DEFINE l_oea49         LIKE oea_file.oea49
DEFINE l_oea61         LIKE oea_file.oea61
DEFINE l_oea14         LIKE oea_file.oea14
DEFINE l_ocn03         LIKE ocn_file.ocn03
DEFINE l_ocn04         LIKE ocn_file.ocn04
DEFINE l_oayslip       LIKE oay_file.oayslip
DEFINE l_oayprnt       LIKE oay_file.oayprnt
DEFINE l_count         LIKE type_file.num5  
DEFINE p_fno           LIKE oga_file.oga16

  WHENEVER ERROR CONTINUE
 
  LET g_fno = p_fno   
  LET g_plant_sub = p_plant
  LET g_plant_new = p_plant
  CALL s_gettrandbs()
  LET g_dbs=g_dbs_tra
  CALL s_getlegal(g_plant_sub) RETURNING g_legal_sub

  LET g_success = 'Y'
  CALL t400sub_lock_cl()

  CALL t400sub_y1(l_oea.*)
  
END FUNCTION

FUNCTION t400sub_y1(p_oea)
DEFINE p_oea   RECORD LIKE oea_file.*
DEFINE l_oeb17 LIKE oeb_file.oeb17
DEFINE l_msg   LIKE type_file.chr1000
DEFINE l_oeb   RECORD LIKE oeb_file.*
 
   CALL t400sub_hu2(p_oea.*) IF g_success = 'N' THEN RETURN END IF  #最近交易更新
 
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), 
               " WHERE oeb01 = '",p_oea.oea01,"'  ORDER BY oeb03"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_oeb2_pre FROM g_sql
   DECLARE t400sub_y1_c CURSOR FOR sel_oeb2_pre
   FOREACH t400sub_y1_c INTO l_oeb.*
      IF STATUS THEN
         LET g_errno = STATUS
         LET g_msg  = g_plant_new,"/",g_fno,"/",p_oea.oea01
         CALL s_errmsg('azw01,oea94,oeb01',g_msg,' oea_confirm(foreach t400sub_y1_c):',STATUS,1)
         LET g_success='N'
         ROLLBACK WORK
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      #檢查訂單單價是否低於取出單價(合約訂單不卡)
      IF p_oea.oea00 MATCHES "[12]" THEN
         LET l_oeb17 = l_oeb.oeb17 * (100-g_oaz.oaz185) / 100
         LET l_oeb17 = cl_digcut(l_oeb17,t_azi03)
         IF l_oeb.oeb13 < l_oeb17 THEN
            LET l_msg = 'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
            CASE g_oaz.oaz184
               WHEN 'R'
                  LET g_errno = 'axm-802'
                  LET g_msg  = g_plant_new,"/",g_fno,"/",l_oeb.oeb03 USING '&&&',l_oeb.oeb04
                  LET g_msg1 = " oea_confirm(chk oeb13):"
                  CALL s_errmsg('azw01,oea94,oeb03,oeb04',g_msg,g_msg1,'axm-802',1)
                  LET g_success ='N'
                  ROLLBACK WORK
                  LET g_msg1=' '||' '||g_plant_new||g_fno
                  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
                  LET g_msg=g_msg[1,255]
                  CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
                  LET g_errno=''
                  LET g_msg=''
                  LET g_msg1=''
                  RETURN
               WHEN 'W'
                  LET l_msg = cl_getmsg('axm-802',g_lang)
                  LET l_msg=l_msg CLIPPED,'Seq.:',l_oeb.oeb03 USING '&&&',' Item:',l_oeb.oeb04
                  CALL cl_msgany(10,20,l_msg)
               WHEN 'N'
                  EXIT CASE
            END CASE
         END IF
      END IF
      CALL t400sub_bu3(p_oea.*,l_oeb.*) IF g_success = 'N' THEN RETURN END IF #更新產品客戶
   END FOREACH
END FUNCTION

FUNCTION t400sub_hu2(p_oea)		#最近交易日
DEFINE l_occ RECORD LIKE occ_file.*
DEFINE p_oea RECORD LIKE oea_file.*

   CALL cl_msg("hu2!")          
   OPEN t400sub_cl2 USING p_oea.oea03 
   IF STATUS THEN
      LET g_msg  = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oea94',g_msg,' oea_confirm(OPEN t400sub_cl2):', STATUS, 1)
      CLOSE t400sub_cl2
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = STATUS
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   FETCH t400sub_cl2 INTO l_occ.*      
   IF SQLCA.sqlcode THEN
      LET g_msg  = g_plant_new,"/",g_fno,"/",l_occ.occ01
      CALL s_errmsg('azw01,oea94,occ01',g_msg,' oea_confirm(FETCH t400_sub_cl2):',SQLCA.sqlcode,1)
      CLOSE t400sub_cl2 
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = STATUS
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg 
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=p_oea.oea02 END IF
   IF l_occ.occ172 IS NULL OR l_occ.occ172 < p_oea.oea02 THEN
      LET l_occ.occ172=p_oea.oea02
   END IF
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'occ_file'), 
               "   SET occ16 = '",l_occ.occ16,"', occ172='",l_occ.occ172,"'",
               " WHERE occ01='",p_oea.oea03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE upd_occ_pre FROM g_sql
   EXECUTE upd_occ_pre
   IF STATUS THEN
      LET g_msg  = g_plant_new,"/",g_fno,"/",p_oea.oea03
      CALL s_errmsg('azw01,oea94,oea03',g_msg,' oea_confirm(UPD occ_file):',STATUS,1)
      CLOSE t400sub_cl2   
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = STATUS
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
 
   CALL cl_msg("") 
 
END FUNCTION

FUNCTION t400sub_bu3(p_oea,p_oeb) 				#更新產品客戶
DEFINE p_oea     RECORD LIKE oea_file.*
DEFINE p_oeb     RECORD LIKE oeb_file.*
DEFINE l_fac     LIKE ima_file.ima31_fac       #單位換算率
DEFINE l_ima31   LIKE ima_file.ima31           #銷售單位  
DEFINE l_rate    LIKE oea_file.oea24           #匯率      
DEFINE l_ima33   LIKE ima_file.ima33           #最近售價  
DEFINE l_check   LIKE type_file.chr1
DEFINE l_obk11   LIKE obk_file.obk11
DEFINE l_obk12   LIKE obk_file.obk12
DEFINE l_obk13   LIKE obk_file.obk13
DEFINE l_obk14   LIKE obk_file.obk14
DEFINE l_obkacti LIKE obk_file.obkacti
DEFINE l_exT     LIKE type_file.chr1

   CALL cl_msg("bu3!")
   #更新料件主檔的最近售價ima33                                                                                                  
   #==>單位轉換                                                                                                                  
   LET g_sql="SELECT ima31 FROM ",cl_get_target_table(g_plant_new,'ima_file'), 
             " WHERE ima01= '",p_oeb.oeb04 ,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE sel_ima31_pre FROM g_sql
   EXECUTE sel_ima31_pre INTO l_ima31
   IF p_oeb.oeb05 =l_ima31 THEN                                                                                                  
       LET l_fac = 1                                                                                                             
   ELSE                                                                                                                          
       CALL s_umfchkm(p_oeb.oeb04,p_oeb.oeb05,l_ima31,g_plant_sub)                                                                            
            RETURNING l_check,l_fac                                                                                              
   END IF                                                                                                                        
   #==>幣別匯率轉換                                                                                                              
   IF p_oea.oea23 =g_aza.aza17 THEN                                                                                              
       LET l_rate =1                                                                                                             
   ELSE                                                                                                                          
       IF p_oea.oea08='1' THEN                                                                                                   
          LET l_exT=g_oaz.oaz52                                                                                                    
       ELSE                                                                                                                      
          LET l_exT=g_oaz.oaz70                                                                                                    
       END IF                                                                                                                    
       CALL s_currm(p_oea.oea23,p_oea.oea02,l_exT,g_plant_sub)
                   RETURNING l_rate                                                                                              
   END IF                                                                                                                        
   #==>更新料件主檔的最近售價                                                                                                    
   LET l_ima33 = (p_oeb.oeb13/l_fac) * l_rate                                                                                    
   CALL cl_digcut(l_ima33,t_azi03)RETURNING l_ima33     
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'ima_file'), 
             "   SET ima33 = '",l_ima33,"'",                                                                                                        
             " WHERE ima01 = '",p_oeb.oeb04,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE upd_ima33_pre FROM g_sql
   EXECUTE upd_ima33_pre                                                                                                    
   IF g_oaz.oaz44 = 'Y' THEN
      LET l_obk11= 'N'
      LET l_obkacti = 'Y'      
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'obk_file'), 
                "   SET obk03='",p_oeb.oeb11,"',",
                "       obk04='",p_oea.oea02,"'",
                "       obk05='",p_oea.oea23,"'",
                "       obk06='",p_oea.oea21,"'",
                "       obk07='",p_oeb.oeb05,"'",
                "       obk08='",p_oeb.oeb13,"'",
                "       obk09='",p_oeb.oeb12,"'",
                " WHERE obk01 = '",p_oeb.oeb04,"'",
                "   AND obk02 = '",p_oea.oea04,"'",
                "   AND obk05 = '",p_oea.oea24,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE upd_obk03_pre FROM g_sql
      EXECUTE upd_obk03_pre
      IF SQLCA.SQLERRD[3] = 0 THEN
        LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'obk_file'), 
                  " (obk01,obk02,",
                             "obk03,obk04,obk05,obk06,obk07,obk08,obk09,",
                             "obk11,obkacti)",
                  "     VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
        PREPARE ins_obk01_pre FROM g_sql
        EXECUTE ins_obk01_pre USING p_oeb.oeb04,p_oea.oea03,   
                p_oeb.oeb11,p_oea.oea02,p_oea.oea23,p_oea.oea21,
                p_oeb.oeb05, p_oeb.oeb13, p_oeb.oeb12,
                l_obk11,l_obkacti
      END IF
   END IF
 
END FUNCTION

FUNCTION t400sub_exp(p_oea01,p_buf,p_plant,p_fno)
DEFINE p_oea01     LIKE oea_file.oea01  
DEFINE p_tag       LIKE type_file.chr1
DEFINE l_buf       LIKE oay_file.oayslip
DEFINE p_buf       LIKE oay_file.oayslip 
DEFINE l_pmk       RECORD LIKE pmk_file.*
DEFINE p_plant     LIKE azw_file.azw01
DEFINE l_pmk01     LIKE pmk_file.pmk01
DEFINE l_oea40     LIKE oea_file.oea40
DEFINE l_oeb12     LIKE oeb_file.oeb12
DEFINE l_oeb28     LIKE oeb_file.oeb28
DEFINE l_oeb24     LIKE oeb_file.oeb24
DEFINE l_oeb48     LIKE oeb_file.oeb48
DEFINE l_oeb03     LIKE oeb_file.oeb03
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cnt1      LIKE type_file.num5
DEFINE tm RECORD
       wc          STRING,
       oeb01       LIKE oeb_file.oeb01,
       oeb03       LIKE oeb_file.oeb03,
       slip        LIKE oay_file.oayslip
       END RECORD 
DEFINE l_slip      LIKE oay_file.oayslip
DEFINE l_prog_t    STRING
DEFINE l_oea       RECORD LIKE oea_file.*
DEFINE l_gfa       RECORD LIKE gfa_file.*
DEFINE p_row,p_col LIKE type_file.num5
DEFINE li_cnt      LIKE type_file.num5
DEFINE li_success  STRING
DEFINE p_fno       LIKE oga_file.oga16
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
   LET g_fno = p_fno  
   LET g_plant_sub = p_plant
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   CALL s_getlegal(g_plant_sub) RETURNING g_legal_sub

   #重新讀取資料
   LET g_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'),
             " WHERE oea01='",p_oea01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE sel_oea_new FROM g_sql
   EXECUTE sel_oea_new INTO l_oea.*
 
   #此訂單已拋採購單,就不可以再次拋轉
   #單據自動化要產生的且為自動產生的
   #此訂單已拋請購單,就不可以再次拋轉 
   LET tm.slip = p_buf 
   LET tm.wc = "oeb01 = '",l_oea.oea01 CLIPPED,"'" 

   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_oeb24 = 0
 
   LET g_sql = "SELECT DISTINCT oeb03,oeb12,oeb28,oeb24,oeb48 ",
               "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
               " WHERE ",tm.wc 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE t400sub_exp_pre FROM g_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_pre',STATUS,1) END IF
   DECLARE t400sub_exp_c CURSOR FOR t400sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_c',STATUS,1) END IF
   LET g_oeb03 = 0    #MOD-910210 #mark
   LET l_cnt = 1      #FUN-AC0006 add
   FOREACH t400sub_exp_c INTO l_oeb03,l_oeb12,l_oeb28,l_oeb24,l_oeb48  #訂單數量/己轉請購量/己交量 
      IF g_success = "N" THEN                                                                                                        
         LET g_totsuccess = "N"                                                                                                      
         LET g_success = "Y"                                                                                                         
      END IF                                                                                                                         
      IF l_oeb12 - l_oeb28 <= 0 THEN
          CONTINUE FOREACH
      ELSE
         IF l_cnt = 1 THEN   #改成标准写法,同一张订单产生同一张请购单
           #CALL t400sub_ins_pmk(tm.slip,l_oea.oea84,l_oea.oea72) RETURNING l_pmk01             #FUN-CC0082 Mark
            CALL t400sub_ins_pmk(tm.slip,l_oea.oea84,l_oea.oea72,l_oea.oea95) RETURNING l_pmk01 #FUN-CC0082 Add
            CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #加項次避免重覆 
         ELSE
            CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)  #加項次避免重覆
         END IF
         LET l_cnt = l_cnt + 1
         IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
      END IF
      IF l_oeb48='1' THEN
         IF g_success ='Y' THEN
            CALL t420sub_y_upd(l_pmk01,'',g_plant_sub,g_oeb03) 
         END IF
      END IF 
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                                                                                                         
   IF g_success = 'Y' THEN #FUN-C90011 Add
      CALL t400sub_upd_oea(l_pmk01,l_oea.oea01)
   END IF                  #FUN-C90011 Add
   IF g_success = 'Y' THEN
       LET l_prog_t = g_prog
       LET g_prog = 'apmt420'
       LET g_prog = l_prog_t
   ELSE
      RETURN
      LET l_oea.oea40 = ''
   END IF
END FUNCTION

#FUNCTION t400sub_ins_pmk(p_slip,p_oea84,p_oea72)        #FUN-CC0082 Mark
FUNCTION t400sub_ins_pmk(p_slip,p_oea84,p_oea72,p_oea95) #FUN-CC0082 Add
DEFINE l_pmk      RECORD LIKE pmk_file.*
DEFINE li_result  LIKE type_file.num5
DEFINE p_slip     LIKE type_file.chr5
DEFINE p_oea84    LIKE oea_file.oea84
DEFINE p_oea72    LIKE oea_file.oea72
DEFINE p_oea95    LIKE oea_file.oea95 #FUN-CC0082 Add
 
   INITIALIZE l_pmk.* TO NULL
        
   CALL s_auto_assign_no("apm",p_slip,p_oea72,"","pmk_file","pmk01",g_plant_sub,"","")
        RETURNING li_result,l_pmk.pmk01
   LET l_pmk.pmk02 = 'REG'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk30 = 'Y'
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   LET l_pmk.pmk45 = 'Y'         #可用
   LET l_pmk.pmk50 = p_oea95     #生产门店 #FUN-CC0082 Add
   LET g_sql="SELECT smyapr,smysign FROM ",cl_get_target_table(g_plant_new,'smy_file'), 
             " WHERE smyslip = '",p_slip,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_smyapr_pre FROM g_sql
   EXECUTE sel_smyapr_pre INTO l_pmk.pmkmksg,l_pmk.pmksign

   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數
   CALL signm_count(l_pmk.pmksign) RETURNING l_pmk.pmksmax
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today
   IF g_azw.azw04='2' THEN
      LET l_pmk.pmk46='3'
      LET l_pmk.pmk47=p_oea84
   ELSE
      LET l_pmk.pmk46='1'
      LET l_pmk.pmk47=''
   END IF
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
   LET l_pmk.pmkplant = g_plant_sub      #機構別
   LET l_pmk.pmklegal = g_legal_sub        
   LET l_pmk.pmkoriu = g_user      
   LET l_pmk.pmkorig = g_grup      

   LET g_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'pmk_file'),"(",
             "        pmk01,pmk02,pmk03,pmk04,pmk05, ",
             "        pmk06,pmk07,pmk08,pmk09,pmk10, ",
             "        pmk11,pmk12,pmk13,pmk14,pmk15, ",
             "        pmk16,pmk17,pmk18,pmk20,pmk21, ",
             "        pmk22,pmk25,pmk26,pmk27,pmk28, ",
             "        pmk29,pmk30,pmk31,pmk32,pmk40, ",
             "        pmk401,pmk41,pmk42,pmk43,pmk45, ",
             "        pmkprsw,pmkprno,pmkprdt,pmkmksg,pmksign, ",
             "        pmkdays,pmkprit,pmksseq,pmksmax,pmkacti, ",
             "        pmkuser,pmkgrup,pmkmodu,pmkdate,pmkud01, ",
             "        pmkud02,pmkud03,pmkud04,pmkud05,pmkud06, ",
             "        pmkud07,pmkud08,pmkud09,pmkud10,pmkud11, ",
             "        pmkud12,pmkud13,pmkud14,pmkud15,pmkplant, ",
             "        pmklegal,pmk46,pmk47,pmk48,pmkcond, ",
             "        pmkconu,pmkcrat,pmkcont,pmkoriu,pmkorig, ",
             "        pmk49) ",
             " VALUES(?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE ins_pmk_pre FROM g_sql
   EXECUTE ins_pmk_pre USING
             l_pmk.pmk01,l_pmk.pmk02,l_pmk.pmk03,l_pmk.pmk04,l_pmk.pmk05,
             l_pmk.pmk06,l_pmk.pmk07,l_pmk.pmk08,l_pmk.pmk09,l_pmk.pmk10,
             l_pmk.pmk11,l_pmk.pmk12,l_pmk.pmk13,l_pmk.pmk14,l_pmk.pmk15,
             l_pmk.pmk16,l_pmk.pmk17,l_pmk.pmk18,l_pmk.pmk20,l_pmk.pmk21,
             l_pmk.pmk22,l_pmk.pmk25,l_pmk.pmk26,l_pmk.pmk27,l_pmk.pmk28,
             l_pmk.pmk29,l_pmk.pmk30,l_pmk.pmk31,l_pmk.pmk32,l_pmk.pmk40,
             l_pmk.pmk401,l_pmk.pmk41,l_pmk.pmk42,l_pmk.pmk43,l_pmk.pmk45,
             l_pmk.pmkprsw,l_pmk.pmkprno,l_pmk.pmkprdt,l_pmk.pmkmksg,l_pmk.pmksign,
             l_pmk.pmkdays,l_pmk.pmkprit,l_pmk.pmksseq,l_pmk.pmksmax,l_pmk.pmkacti,
             l_pmk.pmkuser,l_pmk.pmkgrup,l_pmk.pmkmodu,l_pmk.pmkdate,l_pmk.pmkud01,
             l_pmk.pmkud02,l_pmk.pmkud03,l_pmk.pmkud04,l_pmk.pmkud05,l_pmk.pmkud06,
             l_pmk.pmkud07,l_pmk.pmkud08,l_pmk.pmkud09,l_pmk.pmkud10,l_pmk.pmkud11,
             l_pmk.pmkud12,l_pmk.pmkud13,l_pmk.pmkud14,l_pmk.pmkud15,l_pmk.pmkplant,
             l_pmk.pmklegal,l_pmk.pmk46,l_pmk.pmk47,l_pmk.pmk48,l_pmk.pmkcond,
             l_pmk.pmkconu,l_pmk.pmkcrat,l_pmk.pmkcont,l_pmk.pmkoriu,l_pmk.pmkorig,  
             l_pmk.pmk49

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_errno = SQLCA.sqlcode   
      LET g_msg=g_plant_new,"/",g_fno,"/",l_pmk.pmk01
      CALL s_errmsg("azw01,oea94,pmk01",g_msg," oea_confirm(INS pmk_file):",SQLCA.sqlcode,1)        
      ROLLBACK WORK
      LET g_msg1='pmk_file'||'ins pmk'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      LET g_success = 'N'
      LET l_pmk.pmk01 =NULL  
   END IF           
   RETURN l_pmk.pmk01
 
END FUNCTION

FUNCTION t400sub_ins_pml_exp(p_pmk01,p_oea01,p_oeb03)
DEFINE p_pmk01  LIKE pmk_file.pmk01   
DEFINE l_oeo    RECORD LIKE oeo_file.*
DEFINE l_oeb03  LIKE oeb_file.oeb03
DEFINE p_oeb03  LIKE oeb_file.oeb03
DEFINE l_qty    LIKE oeb_file.oeb12
DEFINE l_oeb01  LIKE oeb_file.oeb01
DEFINE l_oeb    RECORD LIKE oeb_file.*
DEFINE p_oea01  LIKE oea_file.oea01
 
      LET g_sql=" SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
                " WHERE oeb01 ='",p_oea01,"'",
                "   AND oeb03 ='",p_oeb03,"'",
                "   AND oeb1003!='2'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE t400sub_oeb_pre1 FROM g_sql
      DECLARE t400sub_oeb_curs1 CURSOR FOR t400sub_oeb_pre1
      FOREACH t400sub_oeb_curs1 INTO l_oeb.*
         IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode
            LET g_msg  = g_plant_new,"/",g_fno
            CALL s_errmsg('azw01,oea94',g_msg,' oea_confirm(foreach t400sub_oeb_curs1):',SQLCA.sqlcode,1)  
            ROLLBACK WORK
	    LET g_msg1='oeb_file'||'foreach'||g_plant_new||g_fno   
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_oeb03 = g_oeb03+1   
         CALL t400sub_ins_pml(p_pmk01,l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,    
                            l_oeb.oeb05_fac,l_oeb.oeb12,l_oeb.oeb15,
                            l_oeb.oeb05,l_oeb.oeb06,
                            l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,
                            l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,
                            l_oeb.oeb916,l_oeb.oeb917,
                            l_oeb.oeb41,l_oeb.oeb42,l_oeb.oeb43,l_oeb.oeb1001,   
                            g_oeb03,l_oeb.oeb44,l_oeb.oeb51  #FUN-C90011 Add oeb51
                            ) 
         IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
      END FOREACH
 
END FUNCTION
 
FUNCTION t400sub_upd_oea(p_pmk01,p_oea01)
DEFINE p_pmk01 LIKE pmk_file.pmk01
DEFINE l_oea40 LIKE oea_file.oea40
DEFINE p_oea01 LIKE oea_file.oea01
 
   LET l_oea40 = p_pmk01
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oea_file'), 
             "   SET oea40 = '",l_oea40,"'",
             " WHERE oea01 = '",p_oea01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE upd_oea40_pre FROM g_sql
   EXECUTE upd_oea40_pre  
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_msg=g_plant_new,"/",g_fno,"/",p_oea01
      LET g_errno = SQLCA.sqlcode  
      CALL s_errmsg("azw01,oea94,oea01",g_msg," oea_confirm(UPD oea_file):",SQLCA.sqlcode,1)           
      ROLLBACK WORK
      LET g_msg1='posdg'||'UPD oea_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      LET g_success = 'N'
   END IF
 
END FUNCTION

FUNCTION t400sub_ins_pml(p_pmk01,p_oeb01,p_oeb03,p_oeb04,p_oeb05_fac,p_oeb12,
                         p_oeb15,p_oeb05,p_oeb06,
                         p_oeb910,p_oeb911,p_oeb912,p_oeb913,p_oeb914,
                         p_oeb915,p_oeb916,p_oeb917,p_oeb41,p_oeb42,p_oeb43,p_oeb1001,p_oeb03_2,p_oeb44,p_oeb51) #FUN-C90011 Add oeb51
DEFINE p_pmk01     LIKE pmk_file.pmk01
DEFINE p_oeb01     LIKE oeb_file.oeb01
DEFINE p_oeb03     LIKE oeb_file.oeb03
DEFINE p_oeb04     LIKE oeb_file.oeb04
DEFINE p_oeb05_fac LIKE oeb_file.oeb05_fac
DEFINE p_oeb05     LIKE oeb_file.oeb05
DEFINE p_oeb06     LIKE oeb_file.oeb06
DEFINE p_oeb12     LIKE oeb_file.oeb12
DEFINE p_oeb15     LIKE oeb_file.oeb15
DEFINE p_oeb28     LIKE oeb_file.oeb28
DEFINE p_oeb24     LIKE oeb_file.oeb24
DEFINE p_oeb910    LIKE oeb_file.oeb910
DEFINE p_oeb911    LIKE oeb_file.oeb911
DEFINE p_oeb912    LIKE oeb_file.oeb912
DEFINE p_oeb913    LIKE oeb_file.oeb913
DEFINE p_oeb914    LIKE oeb_file.oeb914
DEFINE p_oeb915    LIKE oeb_file.oeb915
DEFINE p_oeb916    LIKE oeb_file.oeb916
DEFINE p_oeb917    LIKE oeb_file.oeb917
DEFINE p_oeb41     LIKE oeb_file.oeb41
DEFINE p_oeb42     LIKE oeb_file.oeb42
DEFINE p_oeb43     LIKE oeb_file.oeb43
DEFINE p_oeb1001   LIKE oeb_file.oeb1001
DEFINE p_oeb03_2   LIKE oeb_file.oeb03
DEFINE p_oeb44     LIKE oeb_file.oeb44
DEFINE p_oeb51     LIKE oeb_file.oeb51 #FUN-C90011 Add
DEFINE l_ima01     LIKE ima_file.ima01
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_ima05     LIKE ima_file.ima05
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_ima27     LIKE ima_file.ima27
DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3
DEFINE l_ima44     LIKE ima_file.ima44
DEFINE l_ima44_fac LIKE ima_file.ima44_fac
DEFINE l_ima45     LIKE ima_file.ima45
DEFINE l_ima46     LIKE ima_file.ima46
DEFINE l_ima49     LIKE ima_file.ima49
DEFINE l_ima491    LIKE ima_file.ima491
DEFINE l_ima913    LIKE ima_file.ima913
DEFINE l_ima914    LIKE ima_file.ima914
DEFINE l_pan       LIKE type_file.num10
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_double    LIKE type_file.num10
DEFINE l_pml       RECORD LIKE pml_file.* 
DEFINE l_oeb       RECORD LIKE oeb_file.* 
DEFINE l_pmli      RECORD LIKE pmli_file.*
DEFINE l_rty03     LIKE rty_file.rty03       
DEFINE l_rty06     LIKE rty_file.rty06       
 
   CALL t400sub_pml_ini(p_pmk01) RETURNING l_pml.* 
 
   LET l_ima913 = 'N'   
   IF p_oeb04[1,4] <> "MISC" THEN
       LET g_sql="SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac,", 
                 "       ima45,ima46,ima49,ima491,",
                 "       ima913,ima914 ",         
                 "  FROM ",cl_get_target_table(g_plant_new,'ima_file'), 
                 " WHERE ima01 = '",p_oeb04,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
       PREPARE sel_ima01_pre FROM g_sql
       EXECUTE sel_ima01_pre INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914 
       IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode  
           LET g_msg=g_plant_new,"/",g_fno,"/",p_oeb04
           CALL s_errmsg("azw01,oea94,ima01",g_msg," oea_confirm(SEL ima):",SQLCA.sqlcode,1)     
           ROLLBACK WORK
	   LET g_msg1='ima_file'||'sel ima'||g_plant_new||g_fno   
	   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	   LET g_msg=g_msg[1,255]
	   CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	   LET g_errno=''
	   LET g_msg=''
	   LET g_msg1=''
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml02 = p_oeb03_2   
       LET l_pml.pml49 = p_oeb44    
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_ima02
       LET l_pml.pml05 = NULL      
       LET l_pml.pml07 = l_ima44      
       LET l_pml.pml08 = l_ima25
       CALL s_umfchkm(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08,g_plant_sub) RETURNING l_flag,l_pml.pml09                                                                             
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
       #先將訂單數量轉換成請購單位數量                                                                                               
       LET p_oeb12 = p_oeb12 * p_oeb05_fac / l_pml.pml09
       LET p_oeb28=0
       LET p_oeb24=0
       LET g_sql="SELECT oeb28,oeb24 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), 
                 " WHERE oeb01='",p_oeb01,"'",
                 "   AND oeb03='",p_oeb03,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
       PREPARE sel_oeb28_pre FROM g_sql
       EXECUTE sel_oeb28_pre INTO p_oeb28,p_oeb24 
       IF cl_null(p_oeb28) THEN LET p_oeb28 = 0 END IF
       IF cl_null(p_oeb24) THEN LET p_oeb24 = 0 END IF
       LET p_oeb12 = (p_oeb12-p_oeb28-p_oeb24) 
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = p_oeb12
       LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)
       LET l_pml.pml35 = p_oeb15                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  
   END IF
   LET l_pml.pml55 = p_oeb51   #交貨時間 #FUN-C90011 Add
   LET l_pml.pml80 = p_oeb910
   LET l_pml.pml81 = p_oeb911
   LET l_pml.pml82 = p_oeb912
   LET l_pml.pml83 = p_oeb913
   LET l_pml.pml84 = p_oeb914
   LET l_pml.pml85 = p_oeb915
   LET l_pml.pml86 = p_oeb916
   LET l_pml.pml12 = p_oeb41
   LET l_pml.pml121 = p_oeb42
   LET l_pml.pml122 = p_oeb43
   LET l_pml.pml90 = p_oeb1001
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pml.pml86 = p_oeb916
   ELSE
      LET l_pml.pml86 = l_pml.pml07
   END IF
   LET g_pml.* = l_pml.*      
   CALL t400_set_pml87()      
   LET l_pml.pml87=g_pml.pml87      
   LET l_pml.pml87 = s_digqty(l_pml.pml87,l_pml.pml86)
   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否
 
   LET l_pml.pml24 = p_oeb01
   LET l_pml.pml25 = p_oeb03
   IF g_azw.azw04='2' THEN
      LET l_pml.pml47 = ''
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file                                                                     
       WHERE rty01=g_plant_sub AND rty02=p_oeb04                                                                            
      IF SQLCA.sqlcode=100 THEN         
         LET l_rty03= ' '
         LET l_rty06= '1'
      END IF                                                                                                              
      LET l_pml.pml49=l_rty06                                                                                                 
      LET l_pml.pml50=l_rty03                                                                                                 
      IF l_pml.pml50='2' THEN                                                                                                 
         LET l_pml.pml51=g_plant_sub                                                                                         
         LET l_pml.pml52=p_pmk01                                                                                          
         LET l_pml.pml53=l_pml.pml02                                                                                    
      ELSE                                                                                                                          
         LET l_pml.pml51=''                                                                                                   
         LET l_pml.pml52=''                                                                                                   
         LET l_pml.pml53=''                                                                                                   
      END IF           
      LET g_sql="SELECT rty05 FROM rty_file",
                " WHERE rty01= (SELECT oea84 FROM ",cl_get_target_table(g_plant_new,'oea_file'), 
                " WHERE oea01='",p_oeb01,"')",
                "   AND rtyacti='Y' AND rty02='",p_oeb04,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE sel_rty05_pre FROM g_sql
      EXECUTE sel_rty05_pre INTO l_pml.pml48
      IF SQLCA.sqlcode=100 THEN
         SELECT rty05 INTO l_pml.pml48 FROM rty_file                                                                 
          WHERE rty01=g_plant_sub AND rtyacti='Y' AND rty02=p_oeb04                                                  
         IF SQLCA.sqlcode=100 THEN                                                                                              
            LET l_pml.pml48=null                                                                                          
         END IF  
      END IF                                                                                                                
      LET l_pml.pml54='2'
   ELSE
      LET l_pml.pml47=''
      LET l_pml.pml48=''
      LET l_pml.pml49='1'
      LET l_pml.pml50='1'
      LET l_pml.pml51=''
      LET l_pml.pml52=''
      LET l_pml.pml53=''
      LET l_pml.pml54=' '
   END IF                                                                                       
   LET l_pml.pml56 = '1'  
   LET l_pml.pml91 = ' '  
   LET l_pml.pml92 = 'N' 
   
   LET g_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'pml_file'),"(",
             "        pml01,pml011,pml02,pml03,pml04, ",
             "        pml041,pml05,pml06,pml07,pml08, ",
             "        pml09,pml10,pml11,pml12,pml121, ",
             "        pml122,pml123,pml13,pml14,pml15, ",
             "        pml16,pml18,pml20,pml21,pml23, ",
             "        pml30,pml31,pml32,pml33,pml34, ",
             "        pml35,pml38,pml40,pml41,pml42, ",
             "        pml43,pml431,pml44,pml45,pml46, ",
             "        pml66,pml67,pml80,pml81,pml82, ",
             "        pml83,pml84,pml85,pml86,pml87, ",
             "        pml88,pml88t,pml31t,pml190,pml191, ",
             "        pml192,pml930,pml24,pml25,pml401, ",
             "        pml90,pmlud01,pmlud02,pmlud03,pmlud04, ",
             "        pmlud05,pmlud06,pmlud07,pmlud08,pmlud09, ",
             "        pmlud10,pmlud11,pmlud12,pmlud13,pmlud14, ",
             "        pmlud15,pml91,pmlplant,pmllegal,pml47, ",
             "        pml48,pml49,pml50,pml51,pml52, ",
             "        pml53,pml54,pml55,pml56,pml92, ",
             "        pml93,pml919,pml57) ",
             " VALUES(?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?,?,?,   ?,?,?,?,?, ",
             "        ?,?,?) "

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE ins_pml_pre FROM g_sql
   EXECUTE ins_pml_pre USING 
             l_pml.pml01,l_pml.pml011,l_pml.pml02,l_pml.pml03,l_pml.pml04,
             l_pml.pml041,l_pml.pml05,l_pml.pml06,l_pml.pml07,l_pml.pml08,
             l_pml.pml09,l_pml.pml10,l_pml.pml11,l_pml.pml12,l_pml.pml121,
             l_pml.pml122,l_pml.pml123,l_pml.pml13,l_pml.pml14,l_pml.pml15,
             l_pml.pml16,l_pml.pml18,l_pml.pml20,l_pml.pml21,l_pml.pml23,
             l_pml.pml30,l_pml.pml31,l_pml.pml32,l_pml.pml33,l_pml.pml34,
             l_pml.pml35,l_pml.pml38,l_pml.pml40,l_pml.pml41,l_pml.pml42,
             l_pml.pml43,l_pml.pml431,l_pml.pml44,l_pml.pml45,l_pml.pml46,
             l_pml.pml66,l_pml.pml67,l_pml.pml80,l_pml.pml81,l_pml.pml82,
             l_pml.pml83,l_pml.pml84,l_pml.pml85,l_pml.pml86,l_pml.pml87,
             l_pml.pml88,l_pml.pml88t,l_pml.pml31t,l_pml.pml190,l_pml.pml191,
             l_pml.pml192,l_pml.pml930,l_pml.pml24,l_pml.pml25,l_pml.pml401,
             l_pml.pml90,l_pml.pmlud01,l_pml.pmlud02,l_pml.pmlud03,l_pml.pmlud04,
             l_pml.pmlud05,l_pml.pmlud06,l_pml.pmlud07,l_pml.pmlud08,l_pml.pmlud09,
             l_pml.pmlud10,l_pml.pmlud11,l_pml.pmlud12,l_pml.pmlud13,l_pml.pmlud14,
             l_pml.pmlud15,l_pml.pml91,l_pml.pmlplant,l_pml.pmllegal,l_pml.pml47,
             l_pml.pml48,l_pml.pml49,l_pml.pml50,l_pml.pml51,l_pml.pml52,
             l_pml.pml53,l_pml.pml54,l_pml.pml55,l_pml.pml56,l_pml.pml92,
             l_pml.pml93,l_pml.pml919,l_pml.pml57

   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode   
      LET g_msg=g_plant_new,"/",g_fno,"/",l_pml.pml01
      CALL s_errmsg("azw01,oea94,pml01",g_msg," oea_confirm(INS pml_file):",SQLCA.sqlcode,1)          
      ROLLBACK WORK
      LET g_msg1='pml_file'||'INS pml_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      LET g_success = 'N'
      RETURN
   END IF
   LET g_sql=" SELECT COALESCE(SUM(pml20),0)",  
             "   FROM ",cl_get_target_table(g_plant_new,'pml_file'),",",  
                        cl_get_target_table(g_plant_new,'pmk_file'),      
             "  WHERE pml24 = '",l_pml.pml24,"'",
             "    AND pml25 = '",l_pml.pml25,"'",
             "    AND pml01 = pmk01",
             "    AND pmk18 <> 'X'",
             "    AND pml16 <> '9'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_pml20_pre FROM g_sql
   EXECUTE sel_pml20_pre INTO l_pml.pml20 
   #要回寫每張訂單的己拋量和請購單號
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oeb_file'), 
             "   SET oeb27 = '",p_pmk01,"',",
             "       oeb28 = '",l_pml.pml20,"'", 
             " WHERE oeb01 = '",p_oeb01,"'",
             "   AND oeb03 = '",p_oeb03,"'"    
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE upd_oeb27_pre FROM g_sql
   EXECUTE upd_oeb27_pre
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode   
      LET g_msg=g_plant_new,"/",g_fno,"/",p_oeb01,"/",p_oeb03                       
      CALL s_errmsg("azw01,oea94,oeb01,oeb03",g_msg," oea_confirm(UPD oeb_file):",SQLCA.sqlcode,1)    
      ROLLBACK WORK
      LET g_msg1='oeb_file'||'UPD oeb_file'||g_plant_new||g_fno   
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION t400sub_pml_ini(p_pmk01)
DEFINE p_pmk01 LIKE pmk_file.pmk01
DEFINE l_pmk02 LIKE pmk_file.pmk02
DEFINE l_pmk25 LIKE pmk_file.pmk25
DEFINE l_pmk13 LIKE pmk_file.pmk13
DEFINE l_pml   RECORD LIKE pml_file.*
 
   INITIALIZE l_pml.* TO NULL
   LET g_sql = "SELECT pmk02,pmk25,pmk13 FROM ",cl_get_target_table(g_plant_new,'pmk_file'), 
               " WHERE pmk01 = '",p_pmk01,"'" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_pmk02_pre FROM g_sql
   EXECUTE sel_pmk02_pre INTO l_pmk02,l_pmk25,l_pmk13
   LET l_pml.pml01 = p_pmk01               LET l_pml.pml011 = l_pmk02
   LET l_pml.pml16 = l_pmk25
   LET l_pml.pml14 = g_sma.sma886[1,1]     LET l_pml.pml15  =g_sma.sma886[2,2]
   LET l_pml.pml23 = 'Y'                   LET l_pml.pml38  ='Y'
   LET l_pml.pml43 = 0                     LET l_pml.pml431 = 0
   LET l_pml.pml11 = 'N'                   LET l_pml.pml13  = 0
   LET l_pml.pml21  = 0
   LET l_pml.pml30 = 0                     LET l_pml.pml32 = 0
   LET l_pml.pml930=s_costcenter(l_pmk13) 
   LET l_pml.pmlplant=g_plant_sub  
   LET l_pml.pmllegal=g_legal_sub
   RETURN l_pml.*
END FUNCTION

FUNCTION t400_set_pml87()
DEFINE    l_item   LIKE img_file.img01     #料號
DEFINE    l_ima25  LIKE ima_file.ima25     #ima單位
DEFINE    l_ima44  LIKE ima_file.ima44     #ima單位
DEFINE    l_ima906 LIKE ima_file.ima906
DEFINE    g_cnt    LIKE type_file.num5
DEFINE    l_fac2   LIKE img_file.img21     #第二轉換率
DEFINE    l_qty2   LIKE img_file.img10     #第二數量
DEFINE    l_fac1   LIKE img_file.img21     #第一轉換率
DEFINE    l_qty1   LIKE img_file.img10     #第一數量
DEFINE    l_tot    LIKE img_file.img10     #計價數量
DEFINE    l_factor LIKE type_file.num20_6
 
    LET g_sql="SELECT ima25,ima44,ima906",
              "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),
              " WHERE ima01='",g_pml.pml04,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
    PREPARE sel_ima25_pre FROM g_sql
    EXECUTE sel_ima25_pre INTO l_ima25,l_ima44,l_ima906
    
    IF SQLCA.sqlcode =100 THEN
       IF g_pml.pml04 MATCHES 'MISC*' THEN
          LET g_sql="SELECT ima25,ima44,ima906",
                    "  FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                    " WHERE ima01='MISC'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
          PREPARE sel_misc_pre FROM g_sql
          EXECUTE sel_misc_pre INTO l_ima25,l_ima44,l_ima906
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=g_pml.pml84
    LET l_qty2=g_pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pml.pml81
       LET l_qty1=g_pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml.pml20
       CALL s_umfchkm(g_pml.pml04,g_pml.pml07,l_ima44,g_plant_sub)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchkm(g_pml.pml04,l_ima44,g_pml.pml86,g_plant_sub)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pml.pml87 = l_tot
END FUNCTION

#Note:出貨單確認過帳
#FUNCTION p200_sub_oga(p_oga01,p_azw01)            #FUN-CC0082 Mark
FUNCTION p200_sub_oga(p_oga01,p_azw01,p_ordershop) #FUN-CC0082 Add
DEFINE p_oga01     LIKE oga_file.oga01
DEFINE p_azw01     LIKE azw_file.azw01
DEFINE p_ordershop LIKE azw_file.azw02	 #FUN-CC0082 Add

   WHENEVER ERROR CONTINUE #FUN-C90065 Add

   LET g_plant_sub = p_azw01
   LET g_plant_ord = p_ordershop  #FUN-CC0082 Add
   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_sub,'oga_file'),
              " WHERE oga01 = '",p_oga01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
   PREPARE sel_oga_pre FROM g_sql
   EXECUTE sel_oga_pre INTO g_oga.*
   LET g_fno = g_oga.oga98   #Add By shi
   LET g_plant_new = p_azw01 #Add By shi

   IF g_oga.oga02 <= g_sma.sma53 THEN
     #Mod By shi Begin---
     #CALL s_errmsg('','','','mfg9999',1)
      LET g_msg  = g_plant_new,"/",g_fno
      LET g_msg1 = " oga_post(chk oga02):"
      CALL s_errmsg('azw01,oga98',g_msg,g_msg1,'mfg9999',1)
     #Mod By shi End-----
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno='mfg9999'                          
      LET g_msg1=' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

  #FUN-CA0091 Mark Begin --- #FUN-CB0103 ReMark
   LET g_sql = "SELECT * FROM ",cl_get_target_table(p_azw01,'ogb_file'),
               " WHERE ogb01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
   PREPARE sel_ogb_pre FROM g_sql
   DECLARE sel_ogb_cs CURSOR FOR sel_ogb_pre
   FOREACH sel_ogb_cs INTO g_ogb.*
      IF STATUS THEN
        #Mod By shi Begin---
        #CALL s_errmsg('ogb01',g_oga.oga01,'FOREACH t605_s2_c',STATUS,1)
         LET g_msg  = g_plant_new,"/",g_fno
         LET g_msg1 = " oga_post(FOREACH t605_s2_c):"
         CALL s_errmsg('azw01,oga98',g_msg,g_msg1,STATUS,1)
        #Mod By shi End-----
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_errno = STATUS
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      IF cl_null(g_ogb.ogb04) THEN CONTINUE FOREACH END IF
      IF g_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
      
      CALL p200_sub_upd_oeb(1)
      IF g_success = 'N' THEN RETURN END IF

     #CALL p200_sub_chk_avl_stk(g_ogb.ogb16)
     #IF g_success = 'N' THEN RETURN END IF
      
      CALL p200_sub_update(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,
                           g_ogb.ogb12,g_ogb.ogb05,g_ogb.ogb15_fac,g_ogb.ogb16,'','-')
      IF g_success='N' THEN RETURN END IF
  #FUN-CA0091 Mark End ----- #FUN-CB0103 ReMark

 #FUN-CB0013 Mark Begin ---
 ##FUN-CA0091 Add Begin ---
 ##更新已出貨數量
 # LET g_sql = "UPDATE ",cl_get_target_table(g_plant_sub,'oeb_file'),
 #             "   SET oeb24 = oeb24 + (SELECT ogb16 FROM ",cl_get_target_table(g_plant_sub,'ogb_file'),
 #             "                         WHERE ogb01 = '",g_oga.oga01,"' ",
 #             "                           AND ogb31 IS NOT NULL ",
 #             "                           AND ogb31[1,4] != 'MISC' ",
 #             "                           AND oeb01 = ogb31 ",
 #             "                           AND oeb03 = ogb32) ",
 #             " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_plant_sub,'ogb_file'),
 #             "                WHERE ogb31 IS NOT NULL ",
 #             "                  AND ogb31[1,4] != 'MISC' ",
 #             "                  AND oeb01 = ogb31 ",
 #             "                  AND oeb03 = ogb32 ",
 #             "                  AND ogb01 = '",g_oga.oga01,"') "
 # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
 # CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
 # PREPARE oeb24_cs FROM g_sql
 # EXECUTE oeb24_cs
 # IF STATUS THEN
 #    LET g_msg  = g_plant_new,"/",g_fno
 #    LET g_msg1 = " oga_post(UPD oeb_file):"
 #    CALL s_errmsg('azw01,oga98',g_msg,g_msg1,STATUS,1)
 #    LET g_success = 'N'
 #    ROLLBACK WORK
 #    LET g_errno = STATUS
 #    LET g_msg1=' '||' '||g_plant_new||g_fno
 #    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
 #    LET g_msg=g_msg[1,255]
 #    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
 #    LET g_errno=''
 #    LET g_msg=''
 #    LET g_msg1=''
 #    RETURN
 # END IF

 ##更新庫存
 # IF g_success = 'Y' THEN
 #    CALL s_upimg_p('1',g_oga.oga01,g_plant_sub,g_oga.oga02)
 #    IF g_success = 'N' THEN
 #       RETURN
 #    END IF
 #    CALL s_instlf_p('1',g_oga.oga01,g_plant_sub)
 #    IF g_success = 'N' THEN
 #       RETURN
 #    END IF
 # END IF
 ##FUN-CA0091 Add End -----
 #FUN-CB0103 Mark End -----

   END FOREACH #FUN-CB0103 ReMark
   CALL p200_sub_upd_oea()
END FUNCTION

#FUN-CA0091 Mark Begin --- #FUN-CB0103 ReMark
FUNCTION p200_sub_upd_oeb(p_type)                  #更新訂單已出貨量
DEFINE p_type      LIKE type_file.num5
DEFINE l_qty       LIKE oeb_file.oeb24

   IF cl_null(g_ogb.ogb31) OR cl_null(g_ogb.ogb32) THEN
      RETURN
   END IF
   
   IF p_type = 1 THEN
      LET l_qty = g_ogb.ogb12
   ELSE
      LET l_qty = g_ogb.ogb12 * -1
   END IF
   
   IF NOT cl_null(g_ogb.ogb31) AND g_ogb.ogb31[1,4] !='MISC' THEN
     #LET g_sql = "UPDATE ",cl_get_target_table(g_plant_sub,'oeb_file'),  #FUN-CC0082 Mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_ord,'oeb_file'),  #FUN-CC0082 Add
                  "   SET oeb24= oeb24 + ? ", 
                  " WHERE oeb01 = '",g_ogb.ogb31,"'",
                  "   AND oeb03 = '",g_ogb.ogb32,"'"
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-CC0082 Mark
     #CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql #FUN-CC0082 Mark
      PREPARE oeb24_cs FROM g_sql
      EXECUTE oeb24_cs USING l_qty
      IF STATUS THEN
        #Mod By shi Begin---
        #LET g_showmsg = g_ogb.ogb31,'/',g_ogb.ogb32
        #CALL s_errmsg('ogb31,ogb32',g_showmsg,'UPD oeb24',STATUS,1)
         LET g_msg  = g_plant_new,"/",g_fno,"/",g_ogb.ogb31,"/",g_ogb.ogb32
         LET g_msg1 = " oga_post(UPD oeb_file):"
         CALL s_errmsg('azw01,oga98,ogb31,ogb32',g_msg,g_msg1,STATUS,1)
        #Mod By shi End-----
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_errno = STATUS
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #Mod By shi Begin---
        #LET g_showmsg = g_ogb.ogb31,'/',g_ogb.ogb32
        #CALL s_errmsg('ogb31,ogb32',g_showmsg,'UPD oeb24','axm-134',1)
         LET g_msg  = g_plant_new,"/",g_fno,"/",g_ogb.ogb31,"/",g_ogb.ogb32
         LET g_msg1 = " oga_post(UPD oeb24):"
         CALL s_errmsg('azw01,oga98,ogb31,ogb32',g_msg,g_msg1,'axm-134',1)
        #Mod By shi End-----
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_errno = STATUS
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
   END IF
END FUNCTION
#FUN-CA0091 Mark End ----- #FUN-CB0103 ReMark

#--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
FUNCTION p200_sub_chk_avl_stk(p_qty2)
DEFINE p_qty2      LIKE ogc_file.ogc16    ##銷售數量(img 單位)
DEFINE l_oeb19     LIKE oeb_file.oeb19
DEFINE l_avl_stk   LIKE type_file.num15_3
DEFINE l_oeb12     LIKE oeb_file.oeb12
DEFINE l_qoh       LIKE oeb_file.oeb12
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_fac       LIKE ogb_file.ogb15_fac
DEFINE l_n1        LIKE type_file.num15_3
DEFINE l_n2        LIKE type_file.num15_3
DEFINE l_n3        LIKE type_file.num15_3
DEFINE l_flag      LIKE type_file.chr1     #FUN-C80107 add
   
   IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32) THEN
      CALL p200_sub_sel_ima(g_ogb.ogb04)
      IF g_success = 'N' THEN RETURN END IF

     #LET g_sql = "SELECT oeb19 FROM ",cl_get_target_table(g_plant_sub,'oeb_file'),  #FUN-CC0082 Mark
      LET g_sql = "SELECT oeb19 FROM ",cl_get_target_table(g_plant_ord,'oeb_file'),  #FUN-CC0082 Add
                  " WHERE oeb01 = '",g_ogb.ogb31,"' ",
                  "   AND oeb03 = '",g_ogb.ogb32,"' "
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-CC0082 Mark
     #CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql #FUN-CC0082 Mark
      PREPARE oeb19_pl1 FROM g_sql
      DECLARE oeb19_cs1 CURSOR FOR oeb19_pl1
      OPEN oeb19_cs1
      FETCH oeb19_cs1 INTO l_oeb19
      IF STATUS THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb31,'/',g_ogb.ogb32
         CALL s_errmsg('azw01,oga98,ogb31,ogb32',g_msg,' oga_post(FETCH oeb19_cs1):',SQLCA.sqlcode,1)
         LET g_success='N'
         ROLLBACK WORK 
         LET g_errno = STATUS
         LET g_msg1=' '||' '||g_plant_new||g_fno 
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      IF l_oeb19 = 'N' THEN
         CALL s_getstock(g_ogb.ogb04,g_plant_sub) RETURNING  l_n1,l_n2,l_n3
         LET l_avl_stk = l_n3
         IF l_avl_stk IS NULL THEN
            LET l_avl_stk = 0
         END IF
        #LET g_sql =  "SELECT SUM(oeb905*oeb05_fac) FROM ",cl_get_target_table(g_plant_sub,'oeb_file'), #FUN-CC0082 Mark
         LET g_sql =  "SELECT SUM(oeb905*oeb05_fac) FROM ",cl_get_target_table(g_plant_ord,'oeb_file'), #FUN-CC0082 Add
                      " WHERE oeb04 = '",g_ogb.ogb04,"'",
                      "   AND oeb19= 'Y' AND oeb70= 'N'"
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-CC0082 Mark
        #CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql #FUN-CC0082 Mark
         PREPARE oeb12_pl FROM g_sql
         DECLARE oeb12_cs CURSOR FOR oeb12_pl
         OPEN oeb12_cs
         FETCH oeb12_cs INTO l_oeb12
         IF STATUS THEN
            LET g_msg  = g_plant_new,"/",g_fno,"/",g_ogb.ogb04
            CALL s_errmsg('azw01,oga98,oeb04',g_msg,' oga_post(FETCH oeb12_cs):',SQLCA.sqlcode,1)
            LET g_success='N'
            ROLLBACK WORK 
            LET g_errno = STATUS
            LET g_msg1=' '||' '||g_plant_new||g_fno 
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
         IF l_oeb12 IS NULL THEN
            LET l_oeb12 = 0
         END IF
         LET l_qoh = l_avl_stk - l_oeb12

         CALL s_umfchkm(g_ogb.ogb04,g_ogb.ogb15,g_ima25,g_plant_sub)
              RETURNING l_cnt,l_fac
         IF l_cnt = 1 THEN
            LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb04,"/",g_ogb.ogb15,"/",g_ima25
            CALL s_errmsg('azw01,oga98,ima01,img09,ima25',g_msg,' oga_post(chk fac):','mfg3075',1)
            LET g_success = 'N'
            ROLLBACK WORK 
            LET g_errno = 'mfg3075'
            LET g_msg1=' '||' '||g_plant_new||g_fno 
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
         LET p_qty2 = p_qty2 * l_fac

        INITIALIZE l_flag TO NULL                                                     #FUN-C80107
       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],g_ogb.ogb09) RETURNING l_flag  #FUN-C80107  #FUN-D30024
        CALL s_inv_shrt_by_warehouse(g_ogb.ogb09,g_plant_sub) RETURNING l_flag                    #FUN-D30024 #TQC-D40078 g_plant_sub
       #IF l_qoh < p_qty2 AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail              #FUN-C80107 mark
        IF l_qoh < p_qty2 AND l_flag='N' THEN  #量不足時,Fail                         #FUN-C80107 
            LET g_msg = g_plant_new,"/",g_fno,"/",l_qoh,"/",p_qty2
            CALL s_errmsg('azw01,oga98,oeb905,l_avl_stk',g_msg,' oga_post(chk qoh):QOH<0','mfg-026',1)
            LET g_success='N'
            ROLLBACK WORK 
            LET g_errno = 'mfg-026'
            LET g_msg1=' '||' '||g_plant_new||g_fno 
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION p200_sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_type)
DEFINE p_flag    LIKE type_file.chr1
DEFINE p_ware    LIKE ogb_file.ogb09        #倉庫
DEFINE p_loca    LIKE ogb_file.ogb091       #儲位
DEFINE p_lot     LIKE ogb_file.ogb092       #批號
DEFINE p_qty     LIKE ogc_file.ogc12        #銷售數量(銷售單位)
DEFINE p_uom     LIKE tlf_file.tlf11        #銷售單位
DEFINE p_factor  LIKE ogb_file.ogb15_fac    #轉換率
DEFINE p_qty2    LIKE ogc_file.ogc16        #銷售數量(img 單位)
DEFINE p_type    LIKE type_file.chr1 
DEFINE l_qty     LIKE ogc_file.ogc12        #異動后數量
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_img     RECORD
                 img10   LIKE img_file.img10,
                 img16   LIKE img_file.img16,
                 img23   LIKE img_file.img23,
                 img24   LIKE img_file.img24,
                 img09   LIKE img_file.img09,
                 img18   LIKE img_file.img18,
                 img21   LIKE img_file.img21
                 END RECORD 
DEFINE l_ima120  LIKE ima_file.ima120

  #Add By shi
  #IF s_joint_venture(g_ogb.ogb04,g_plant_new) OR NOT s_internal_item(g_ogb.ogb04,g_plant_new) THEN
  #   RETURN
  #END IF
  #Add By shi

   LET g_sql = "SELECT ima25,ima86,ima120 FROM ",cl_get_target_table(g_plant_sub,'ima_file'),
               " WHERE ima01= '",g_ogb.ogb04,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
   PREPARE sel_ima_confirm_pre FROM g_sql
   EXECUTE sel_ima_confirm_pre INTO g_ima25,g_ima86,l_ima120

   IF g_ogb.ogb44 = '4' OR l_ima120 = '2' THEN 
      RETURN
   END IF

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0   END IF
   
   IF p_uom IS NULL THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb03,"/",g_ogb.ogb04
      CALL s_errmsg('azw01,oga98,ogb03,ogb04',g_msg,' oga_post(chk uom):uom is null','axm-186',1) #出庫單位空白,不可過帳
      LET g_success = 'N' 
      ROLLBACK WORK 
      LET g_errno = 'axm-186'
      LET g_msg1=' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

   LET l_cnt = 0 
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sub,'img_file'),
               " WHERE img01= ? AND img02= ? AND img03= ? ",
               "   AND img04= ? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
   PREPARE sel_count_img_pre FROM g_sql
   EXECUTE sel_count_img_pre USING g_ogb.ogb04,p_ware,p_loca,p_lot INTO l_cnt
   IF l_cnt=0 THEN
      #固定將 g_sma.sma892 變數的第二碼設為 'N' g_sma.sma39 變數設為 'Y'
      LET g_sma.sma892[2,2] = 'N'
      LET g_sma.sma39 = 'Y'
      CALL s_add_img(g_ogb.ogb04,p_ware,p_loca,p_lot,g_oga.oga01,g_ogb.ogb03,g_oga.oga02)
      IF g_success='N' THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb03,"/",g_ogb.ogb04
         CALL s_errmsg('azw01,oga98,ogb03,ogb04',g_msg,' oga_post(add img):','',1) 
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_errno = ''
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
   END IF
   
   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img18,img21 ",
                      "  FROM ",cl_get_target_table(g_plant_sub,'img_file'),
                      " WHERE img01= ? AND img02= ? AND img03= ? ",
                      "   AND img04= ? FOR UPDATE "
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql
   CALL cl_parse_qry_sql(g_forupd_sql,g_plant_sub) RETURNING g_forupd_sql
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE sel_img_lock CURSOR FROM g_forupd_sql
   OPEN sel_img_lock USING g_ogb.ogb04,p_ware,p_loca,p_lot
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode
      LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('azw01,oga98,img01,img02,img03,img04',g_msg,' oga_post(OPEN img_lock):',SQLCA.sqlcode,1)
      CLOSE sel_img_lock
      LET g_success = 'N'
      ROLLBACK WORK 
      LET g_msg1= ' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   
   FETCH sel_img_lock INTO l_img.*
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode
      LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('azw01,oga98,img01,img02,img03,img04',g_msg,' oga_post(FETCH img_lock):',SQLCA.sqlcode,1)
      LET g_success = 'N'
      ROLLBACK WORK 
      LET g_msg1=' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

   IF l_img.img18 < g_oga.oga02 AND p_type <> '+' THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",l_img.img18,'/',g_oga.oga02
      CALL s_errmsg('azw01,oga98,img18,oga02',g_msg,' oga_post(chk oga02):img18<oga02','aim-400',1) #此料倉儲已超過有效日期請重新輸入!
      LET g_success='N'
      ROLLBACK WORK 
      LET g_errno = 'aim-400'
      LET g_msg1=' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 - p_qty2

   IF p_type = '+' THEN LET l_cnt =  1 END IF
   IF p_type = '-' THEN LET l_cnt = -1 END IF

   CALL s_mupimg(l_cnt,g_ogb.ogb04,p_ware,p_loca,p_lot,p_qty2,
                 g_today,g_plant_sub CLIPPED ,-1,g_ogb.ogb01,g_ogb.ogb03)

   IF g_success='N' THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('azw01,oga98,img01,img02,img03,img04',g_msg,' oga_post(s_upimg):','9050',1)
      ROLLBACK WORK 
      LET g_errno = '9050'
      LET g_msg1=' '||' '||g_plant_new||g_fno 
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

  #LET g_forupd_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(g_plant_sub,'ima_file'),
  #                   " WHERE ima01= ?  FOR UPDATE "
  #CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql
  #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  #DECLARE sel_ima_lock CURSOR FROM g_forupd_sql

  #OPEN sel_ima_lock USING g_ogb.ogb04
  #IF STATUS THEN
  #   CALL s_errmsg('ima01',g_ogb.ogb04,"OPEN ima_lock:", STATUS, 1)
  #   CLOSE sel_ima_lock
  #   LET g_success='N'
  #   ROLLBACK WORK
  #   LET g_errno = STATUS
  #   LET g_msg1='OPEN ima_lock'||' '||g_plant_new||g_fno
  #   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #   LET g_msg=g_msg[1,255]
  #   CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #   LET g_errno=''
  #   LET g_msg=''
  #   LET g_msg1=''
  #   RETURN
  #END IF
  #
  #FETCH sel_ima_lock INTO g_ima25,g_ima86
  #IF STATUS THEN
  #   CALL s_errmsg('ima01',g_ogb.ogb04,'FETCH sel_ima_lock',STATUS,1) 
  #   CLOSE sel_ima_lock
  #   LET g_success='N' 
  #   ROLLBACK WORK
  #   LET g_errno = STATUS
  #   LET g_msg1=' '||' '||g_plant_new||g_fno
  #   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #   LET g_msg=g_msg[1,255]
  #   CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #   LET g_errno=''
  #   LET g_msg=''
  #   LET g_msg1=''
  #   RETURN
  #END IF

  ##料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
  #CALL s_mudima(g_ogb.ogb04,g_plant_sub)
   IF g_success='Y' AND p_type = '-' THEN
     #FUN-CC0082 Mark&Add Begin ---
     #CALL p200_sub_oga_tlf(p_ware,p_loca,p_lot,g_ima25,p_qty,l_qty,p_uom,p_factor,p_flag)
                     #门店       #料件编号   #仓库           #储位        #批号
      CALL s_ins_tlf(g_plant_sub,g_ogb.ogb04,g_ogb.ogb09,    g_ogb.ogb091,g_ogb.ogb092,
                     #数量       #类型       #单据编号       #项次        #单据编号(参)
                     g_ogb.ogb16,'1',        g_ogb.ogb01,    g_ogb.ogb03, g_ogb.ogb31,
                     #项次(参)   #单位       #转换率         #客户        #日期
                     g_ogb.ogb32,g_ogb.ogb05,g_ogb.ogb05_fac,g_oga.oga03, g_oga.oga02)
     #FUN-CC0082 Mark&Add End -----
   END IF
END FUNCTION

FUNCTION p200_sub_sel_ima(p_ima01)
DEFINE p_ima01     LIKE ima_file.ima01

   LET g_ima906 = NULL
   LET g_ima25  = NULL
   LET g_sql = " SELECT ima906,ima25 ",
               "  FROM ",cl_get_target_table(g_plant_sub,'ima_file'),
               " WHERE ima01 = '",p_ima01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
   PREPARE ima_sel FROM g_sql
   EXECUTE ima_sel INTO g_ima906,g_ima25
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode
      LET g_msg = g_plant_new,"/",g_fno,"/",p_ima01
      CALL s_errmsg('azw01,oga98,ima01',g_msg,' oga_post(ima_sel):',SQLCA.sqlcode,1)
      LET g_success='N'
      ROLLBACK WORK
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
END FUNCTION

FUNCTION p200_sub_oga_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag)
DEFINE p_ware     LIKE ogb_file.ogb09        #倉庫
DEFINE p_loca     LIKE ogb_file.ogb091       #儲位
DEFINE p_lot      LIKE ogb_file.ogb092       #批號
DEFINE p_unit     LIKE ima_file.ima25        #單位
DEFINE p_qty      LIKE ogc_file.ogc12        #銷售數量(銷售單位)
DEFINE p_img10    LIKE img_file.img10        #異動后數量
DEFINE p_uom      LIKE tlf_file.tlf11        #銷售單位
DEFINE p_factor   LIKE ogb_file.ogb15_fac    #轉換率
DEFINE p_flag     LIKE type_file.chr1
DEFINE l_n1       LIKE type_file.num15_3
DEFINE l_n2       LIKE type_file.num15_3
DEFINE l_n3       LIKE type_file.num15_3
   
   #----來源----
   LET g_tlf.tlf01  = g_ogb.ogb04        #異動料件編號
   LET g_tlf.tlf02  = 50                 #'Stock'
   LET g_tlf.tlf020 = g_ogb.ogb08
   LET g_tlf.tlf021 = p_ware             #倉庫
   LET g_tlf.tlf022 = p_loca             #儲位
   LET g_tlf.tlf023 = p_lot              #批號
   LET g_tlf.tlf024 = p_img10            #異動后數量
   LET g_tlf.tlf025 = p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026 = g_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027 = g_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03  = 724
   LET g_tlf.tlf030 = ' '
   LET g_tlf.tlf031 = ' '                #倉庫
   LET g_tlf.tlf032 = ' '                #儲位
   LET g_tlf.tlf033 = ' '                #批號
   LET g_tlf.tlf034 = ' '                #異動后庫存數量
   LET g_tlf.tlf035 = ' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036 = g_ogb.ogb31        #訂單單號
   LET g_tlf.tlf037 = g_ogb.ogb32        #訂單項次
   #-->異動數量
   LET g_tlf.tlf04 = ' '                 #工作站
   LET g_tlf.tlf05 = ' '                 #作業序號
   LET g_tlf.tlf06 = g_oga.oga02         #發料日期
   LET g_tlf.tlf07 = g_today             #異動資料產生日期
   LET g_tlf.tlf08 = TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09 = g_user              #產生人
   LET g_tlf.tlf10 = p_qty               #異動數量
   LET g_tlf.tlf11 = p_uom               #發料單位
   LET g_tlf.tlf12 = p_factor            #發料/庫存 換算率
   LET g_tlf.tlf13 = 'axmt620'           
   LET g_tlf.tlf14 = g_ogb.ogb1001       #異動原因
                                         
   LET g_tlf.tlf17 = ' '                 #非庫存性料件編號

   CALL s_getstock(g_ogb.ogb04,g_plant_sub) RETURNING l_n1,l_n2,l_n3
   LET g_tlf.tlf18 = l_n2 + l_n3
   IF g_tlf.tlf18 IS NULL THEN
      LET g_tlf.tlf18 = 0
   END IF
   LET g_tlf.tlf19  = g_oga.oga03
   LET g_tlf.tlf20  = g_oga.oga46
   LET g_tlf.tlf61  = g_ima86
   LET g_tlf.tlf62  = g_ogb.ogb31        #參考單號(訂單)
   LET g_tlf.tlf63  = g_ogb.ogb32        #訂單項次
   LET g_tlf.tlf64  = g_ogb.ogb908       #手冊編號
   LET g_tlf.tlf66  = p_flag             #多倉出貨處理
   LET g_tlf.tlf930 = g_ogb.ogb930
   LET g_tlf.tlf20  = g_ogb.ogb41
   LET g_tlf.tlf41  = g_ogb.ogb42
   LET g_tlf.tlf42  = g_ogb.ogb43
   LET g_tlf.tlf43  = g_ogb.ogb1001
   LET g_tlf.tlf99  = g_oga.oga99
   
   CALL s_tlf2(1,0,g_plant_sub)
END FUNCTION

FUNCTION p200_sub_upd_oea()                 #更新訂單出貨金額
DEFINE l_amount     LIKE oea_file.oea62

   IF cl_null(g_oga.oga16) THEN RETURN END IF
  #LET g_sql = "SELECT SUM(ogb14) ",
  #            "  FROM ",cl_get_target_table(g_plant_sub,'ogb_file'),
  #            " WHERE ogb01 = '",g_oga.oga01,"' ",
  #            "   AND ogb31 = '",g_oga.oga16,"' "
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql
  #PREPARE sel_ogb14_sum FROM g_sql
  #EXECUTE sel_ogb14_sum INTO l_amount
  #IF cl_null(l_amount) THEN LET l_amount=0 END IF

  #LET g_sql = "UPDATE ",cl_get_target_table(g_plant_sub,'oea_file'), #FUN-CC0082 Mark
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_ord,'oea_file'), #FUN-CC0082 Add
               "   SET oea62 = oea62+? ",
               " WHERE oea01 = '",g_oga.oga16,"'"

  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-CC0082 Mark
  #CALL cl_parse_qry_sql(g_sql,g_plant_sub) RETURNING g_sql #FUN-CC0082 Mark
   PREPARE oea62_cs FROM g_sql
  #EXECUTE oea62_cs USING l_amount
   EXECUTE oea62_cs USING g_oga.oga50

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",g_ogb.ogb31
      CALL s_errmsg('azw01,oga98,oea01',g_msg,' oga_post(upd oea62):',status,1)
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = STATUS
      LET g_msg1='upd oea_file'||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
END FUNCTION

#經營方式處理

#Note:原sapcp200_oha.4gl
FUNCTION p200_sub_oha_confirm(p_oha01,p_plant,p_fno)
DEFINE p_oha01       LIKE oha_file.oha01
DEFINE p_plant       LIKE azw_file.azw01 
DEFINE l_legal       LIKE oga_file.ogalegal
DEFINE p_fno         LIKE oga_file.oga16 

   WHENEVER ERROR CONTINUE #FUN-C90065 Add

   LET g_plant_new = p_plant
   LET g_fno       = p_fno
   LET g_azw01     = p_plant 
   CALL s_getlegal(p_plant) RETURNING l_legal
   LET g_legal_sub = l_legal
   LET g_plant_sub = p_plant
   
   IF g_success = "Y" THEN
      LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                 " WHERE oha01 ='",p_oha01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 						
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p200_oha_pre FROM g_sql
      EXECUTE p200_oha_pre INTO g_oha.*
      
      CALL p200_sub_oha_chk()      
      IF g_success = "Y" THEN
         CALL p200_sub_oha_upd()  
         IF g_success = 'N' THEN RETURN END IF
         CALL p200_sub_oha_s('1')
      ELSE
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION p200_sub_oha_chk()
DEFINE l_yy,l_mm   LIKE type_file.num5      
DEFINE l_cnt       LIKE type_file.num5     
DEFINE l_ohb12     LIKE ohb_file.ohb12 
DEFINE l_ohb       RECORD LIKE ohb_file.*  
DEFINE l_rvbs06    LIKE rvbs_file.rvbs06  
DEFINE l_rxx04     LIKE rxx_file.rxx04    
DEFINE l_ohb14t    LIKE ohb_file.ohb14t   
DEFINE l_ohb13     LIKE ohb_file.ohb13
DEFINE l_ohb03     LIKE ohb_file.ohb03
DEFINE l_ohb33     LIKE ohb_file.ohb33 
DEFINE l_ohb34     LIKE ohb_file.ohb34 
DEFINE l_img09     LIKE img_file.img09     
DEFINE l_ohb05_fac LIKE ohb_file.ohb05_fac 
DEFINE g_cnt       LIKE type_file.num10    
DEFINE l_ohb50     LIKE ohb_file.ohb50

   LET g_success = 'Y'
  #IF g_oha.oha09 = '6' THEN
  #   LET g_sql ="SELECT ohb33,ohb34 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
  #              " WHERE ohb01 ='",g_oha.oha01,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #   PREPARE oha09_cs_pre FROM g_sql
  #   DECLARE oha09_cs CURSOR FOR oha09_cs_pre
  #   FOREACH oha09_cs INTO l_ohb33,l_ohb34
  #      IF cl_null(l_ohb33) OR cl_null(l_ohb34) THEN
  #         CALL s_errmsg('','','','abx-070',1)
  #         LET g_success = 'N'
  #         ROLLBACK WORK
  #         LET g_errno = 'abx-070'
  #         LET g_msg1=' '||' '||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         RETURN
  #      END IF
  #   END FOREACH
  #END IF

  #LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
  #            " WHERE ohb01 = '",g_oha.oha01,"' "
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql					
  #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #PREPARE p200sub_ohbrvbs_pre FROM g_sql
  #DECLARE p200sub_ohbrvbs CURSOR FOR p200sub_ohbrvbs_pre

  #FOREACH p200sub_ohbrvbs INTO l_ohb.*
  #   LET g_sql = "SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
  #               " WHERE imaacti = 'Y' AND ima01 = '",l_ohb.ohb04,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql					
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #   PREPARE ima918_ima921_pre FROM g_sql
  #   EXECUTE ima918_ima921_pre INTO g_ima918,g_ima921

  #   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
  #      LET g_sql = "SELECT SUM(rvbs06) FROM ",cl_get_target_table(g_plant_new,'rvbs_file'),
  #                  " WHERE rvbs13 = 0 AND rvbs09 = 1 ",
  #                  " AND rvbs00 = '",g_prog,"' ",
  #                  " AND rvbs01 = '",l_ohb.ohb01,"' ",
  #                  " AND rvbs02 = '",l_ohb.ohb03,"' "
  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 						
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
  #      PREPARE rvbs06_sum_pre FROM g_sql
  #      EXECUTE rvbs06_sum_pre INTO l_rvbs06

  #      IF cl_null(l_rvbs06) THEN
  #         LET l_rvbs06 = 0
  #      END IF

  #      SELECT img09 INTO l_img09 FROM img_file
  #       WHERE img01= l_ohb.ohb04  AND img02= l_ohb.ohb09
  #         AND img03= l_ohb.ohb091 AND img04= l_ohb.ohb092
  #      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_img09) RETURNING g_cnt,l_ohb05_fac
  #      IF g_cnt = '1' THEN
  #         LET l_ohb05_fac = 1
  #      END IF             
  #      IF (l_ohb.ohb12 * l_ohb05_fac) <> l_rvbs06 THEN
  #         CALL s_errmsg('ohb04',l_ohb.ohb04,'','aim-011',1)
  #         LET g_success = "N"
  #         ROLLBACK WORK
  #         LET g_errno = 'aim-011'
  #         LET g_msg1=' '||' '||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         RETURN
  #      END IF
  #   END IF
  #   IF g_oha.oha09 = '4' AND cl_null(l_ohb.ohb31) THEN
  #      CALL s_errmsg('','','','axm-889',1)
  #      LET g_success = 'N'
  #      ROLLBACK WORK
  #      LET g_errno = 'aim-011'
  #      LET g_msg1=' '||' '||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      RETURN
  #   END IF
  #END FOREACH

  #IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL
  #   AND g_oha.oha02 <= g_sma.sma53 THEN
  #   CALL s_errmsg('','','','mfg9999',1)
  #   LET g_success = 'N'  
  #   ROLLBACK WORK
  #   LET g_errno = 'mfg9999'
  #   LET g_msg1=' '||' '||g_plant_new||g_fno
  #   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #   LET g_msg=g_msg[1,255]
  #   CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #   LET g_errno=''
  #   LET g_msg=''
  #   LET g_msg1=''
  #   RETURN
  #END IF

   # ---若現行年月大於出貨單/銷退單之年月--不允許確認-----
   CALL s_yp(g_oha.oha02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
      LET g_msg = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oha98',g_msg,' oha_post(chk oha02):','mfg6090',1)
      LET g_success = 'N' 
      ROLLBACK WORK
      LET g_errno = 'mfg6090'
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg 
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

  #IF g_oha.oha09 = '1' OR g_oha.oha09 = '4' OR g_oha.oha09 = '5' THEN
  #   LET g_sql ="SELECT ohb03,ohb13,ohb50 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
  #              " WHERE ohb01 ='",g_oha.oha01,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #   PREPARE p200_y_price_pre FROM g_sql
  #   DECLARE p200_y_price CURSOR FOR p200_y_price_pre

  #   FOREACH p200_y_price INTO l_ohb03,l_ohb13,l_ohb50
  #      IF NOT cl_null(l_ohb50) AND l_ohb50 = g_oaz.oaz88 THEN
  #         CONTINUE FOREACH
  #      END IF
  #     #IF l_ohb13 = 0 THEN
  #     #   CALL s_errmsg('ohb03',l_ohb03,'','axm-534',1)
  #     #   LET g_success = 'N'
  #     #   ROLLBACK WORK
  #     #   LET g_errno = 'axm-534'
  #     #   LET g_msg1=' '||' '||g_plant_new||g_fno
  #     #   CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg 
  #     #   LET g_msg=g_msg[1,255]
  #     #   CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #     #   LET g_errno=''
  #     #   LET g_msg=''
  #     #   LET g_msg1=''
  #     #   RETURN
  #     #END IF
  #   END FOREACH
  #END IF

END FUNCTION 

FUNCTION p200_sub_oha_upd()
DEFINE   l_sql         STRING 

  #LET g_success = 'Y'
  #CALL p200_sub_oha_y1()

  #IF g_success = 'Y' AND g_oaz.oaz63='Y' AND
  #  (g_oha.oha09 MATCHES '[1,4,5]') THEN
  #   CALL p200_sub_oha_CN()
  #END IF

END FUNCTION


FUNCTION p200_sub_oha_CN()      # 產生待抵帳款 (Credit Note)

   IF g_oha.ohaconf = 'N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF g_oha.ohapost = 'N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   IF g_oha.oha10 IS NOT NULL THEN RETURN END IF
   IF cl_null(g_oha.oha09) OR g_oha.oha09 NOT MATCHES '[145]' THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",g_oha.oha09
      CALL s_errmsg('azw01,oha98,oha09',g_msg,' oha_post(chk oha09):','axr-063',1)
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = 'axr-063'
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
  #LET g_msg="axrp304 '",g_oha.oha01,"' '",g_oha.oha09,"' '",g_oha.ohaplant,"' "
  #CALL cl_cmdrun_wait(g_msg)
END FUNCTION


FUNCTION p200_sub_oha_s(p_cmd)
DEFINE p_cmd         LIKE type_file.chr1  # 1.不詢問 2.要詢問       
DEFINE l_sum007      LIKE tsa_file.tsa07
DEFINE l_sum005      LIKE tsa_file.tsa05
DEFINE l_ohb04       LIKE ohb_file.ohb04
DEFINE l_ohb1002     LIKE ohb_file.ohb1002
DEFINE l_ohb12       LIKE ohb_file.ohb12
DEFINE l_ohb14       LIKE ohb_file.ohb14
DEFINE l_ohb14t      LIKE ohb_file.ohb14t
DEFINE l_tqy02       LIKE tqy_file.tqy02
DEFINE l_oay11       LIKE oay_file.oay11
DEFINE l_tqz02       LIKE tqz_file.tqz02
DEFINE l_imm03       LIKE imm_file.imm03   
DEFINE m_ohb12       LIKE ohb_file.ohb12  
DEFINE m_ohb61       LIKE ohb_file.ohb61 
DEFINE m_ohb04       LIKE ohb_file.ohb04
DEFINE m_ohb01       LIKE ohb_file.ohb01 
DEFINE m_ohb03       LIKE ohb_file.ohb03 
DEFINE m_ohb31       LIKE ohb_file.ohb31 
DEFINE m_ohb32       LIKE ohb_file.ohb32 
DEFINE m_qcs091c     LIKE qcs_file.qcs091 
DEFINE l_flag        LIKE type_file.num10      
DEFINE l_ohb         RECORD LIKE ohb_file.*
DEFINE l_tot         LIKE oeb_file.oeb25
DEFINE l_tot1        LIKE oeb_file.oeb26   
DEFINE l_ocn03       LIKE ocn_file.ocn03
DEFINE l_ocn04       LIKE ocn_file.ocn04
DEFINE lj_result     LIKE type_file.chr1  

   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
              " WHERE ohb01 ='",g_oha.oha01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ohb_s_c_pre FROM g_sql
   DECLARE ohb_s_c CURSOR FOR ohb_s_c_pre

   FOREACH ohb_s_c INTO l_ohb.*
      CALL s_incchk(l_ohb.ohb09,l_ohb.ohb091,g_user)
           RETURNING lj_result
      IF NOT lj_result THEN
         LET g_success = 'N'
         LET g_msg = g_plant_new,"/",g_fno,"/",l_ohb.ohb03,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",g_user
         CALL s_errmsg('azw01,oha98,ohb03,ohb09,ohb091,inc03',g_msg,' oha_post(chk inc03):','asf-888',1)
         ROLLBACK WORK
         LET g_errno='asf-888'                           
         LET g_msg1='ohb_file'||'sel'||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      RETURN
   END IF

   IF g_oha.oha02 <= g_oaz.oaz09 THEN
      LET g_msg = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oha98',g_msg,' oha_post(chk oha02):','axm-273',1)
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = 'axm-273'
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND g_oha.oha02 <= g_sma.sma53 THEN
      LET g_msg = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oha98',g_msg,' oha_post(chk oha02):','axm-273',1)
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_errno = 'axm-273'
      LET g_msg1=' '||' '||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg 
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF

  #LET g_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb31,ohb32 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), 
  #            "  WHERE ohb01 = '",g_oha.oha01,"'"
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #PREPARE p200_curs1 FROM g_sql
  #DECLARE p200_pre1 CURSOR FOR p200_curs1

  #FOREACH p200_pre1 INTO m_ohb12,m_ohb61,m_ohb04,m_ohb01,m_ohb31,m_ohb32      
  #   IF m_ohb61 = 'Y' THEN
  #      LET m_qcs091c = 0
  #      LET g_sql ="SELECT SUM(qcs091) FROM ",cl_get_target_table(g_plant_new,'qcs_file'),
  #                 " WHERE qcs01 ='",m_ohb31,"' AND  qcs02=",m_ohb32," AND qcs14 = 'Y' "
  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #      PREPARE qcs091_sum_pre FROM g_sql
  #      EXECUTE qcs091_sum_pre INTO m_qcs091c

  #      IF m_qcs091c IS NULL THEN
  #         LET m_qcs091c = 0
  #      END IF

  #      IF m_ohb12 > m_qcs091c THEN
  #         CALL s_errmsg('ohb04',m_ohb04,'','mfg3558',1)
  #         LET g_success = 'N'
  #         ROLLBACK WORK
  #         LET g_errno = 'mfg3558'
  #         LET g_msg1=' '||' '||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         RETURN
  #      END IF
  #   END IF
  #END FOREACH

   CALL p200_sub_oha_s1()

   IF SQLCA.sqlcode THEN LET g_success='N' END IF

   IF g_success = 'Y' THEN
      IF g_oha.oha05='4'  THEN
         CALL cl_err(g_oga.oga01,'atm-262',1)
         LET g_sql ="SELECT oha1015,oha1018 FROM ",cl_get_target_table(g_plant_new,'oha_file'), 
                    " WHERE oha01 ='",g_oha.oha01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql					
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE oha1015_pre FROM g_sql
         EXECUTE oha1015_pre INTO g_oha.oha1015,g_oha.oha1018
      END IF
      CALL cl_flow_notify(g_oha.oha01,'S')
   END IF

END FUNCTION

FUNCTION p200_sub_oha_s1()
DEFINE  g_oha53        LIKE oha_file.oha53
DEFINE  g_msg          STRING
DEFINE  l_oayauno      LIKE oay_file.oayauno
DEFINE  l_oay16        LIKE oay_file.oay16
DEFINE  l_oay19        LIKE oay_file.oay19
DEFINE  l_oay20        LIKE oay_file.oay20
DEFINE  l_tqk04        LIKE tqk_file.tqk04
DEFINE  l_occ02        LIKE occ_file.occ02
DEFINE  l_occ11        LIKE occ_file.occ11
DEFINE  l_occ07        LIKE occ_file.occ07
DEFINE  l_occ08        LIKE occ_file.occ08
DEFINE  l_occ09        LIKE occ_file.occ09
DEFINE  l_occ1023      LIKE occ_file.occ1023
DEFINE  l_occ1024      LIKE occ_file.occ1024
DEFINE  l_occ1022      LIKE occ_file.occ1022
DEFINE  l_occ1005      LIKE occ_file.occ1005
DEFINE  l_occ1006      LIKE occ_file.occ1006
DEFINE  l_oaytype      LIKE oay_file.oaytype
DEFINE  l_occ1027      LIKE occ_file.occ1027
DEFINE  l_ogb930       LIKE ogb_file.ogb930
DEFINE  l_ogbi         RECORD LIKE ogbi_file.* 
DEFINE  l_flag         LIKE type_file.num5
DEFINE  l_ohbi RECORD  LIKE ohbi_file.* 

   LET l_ogb930=s_costcenter(l_oga.oga15)
   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), 
              " WHERE ohb01 ='",g_oha.oha01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql         
   PREPARE p200_s1_c_pre FROM g_sql
   DECLARE p200_s1_c CURSOR FOR p200_s1_c_pre
   
   FOREACH p200_s1_c INTO b_ohb.*
     IF g_success='N' THEN
        LET g_totsuccess='N'
        LET g_success="Y"
     END IF
     IF STATUS THEN EXIT FOREACH END IF
     LET g_cmd= '_s1() read ohb:',b_ohb.ohb03
     CALL cl_msg(g_cmd)
   
     IF g_oha.oha09 <> '5' THEN
        CALL p200_sub_oha_bu1()     #更新出貨單銷退量
        IF g_success = 'N' THEN
           CONTINUE FOREACH   
        END IF
     
        IF cl_null(b_ohb.ohb04)  THEN CONTINUE FOREACH     END IF
        IF cl_null(b_ohb.ohb09)  THEN LET b_ohb.ohb09=' '  END IF
        IF cl_null(b_ohb.ohb091) THEN LET b_ohb.ohb091=' ' END IF
        IF cl_null(b_ohb.ohb092) THEN LET b_ohb.ohb092=' ' END IF
        IF cl_null(b_ohb.ohb16)  THEN LET b_ohb.ohb16=0    END IF
        # 非MISC的料件且銷退方式不為 5.折讓的才須異動庫存
        IF b_ohb.ohb04[1,4] != 'MISC' AND g_oha.oha09 != '5' THEN 
           IF s_industry('icd') THEN
             SELECT * INTO l_ohbi.* FROM ohbi_file
              WHERE ohbi01 = b_ohb.ohb01 AND ohbi03 = b_ohb.ohb03   
             CALL s_icdpost(1,b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,
                            b_ohb.ohb092,b_ohb.ohb05,b_ohb.ohb12,
                            b_ohb.ohb01,b_ohb.ohb03,g_oha.oha02,'Y',
                            b_ohb.ohb31,b_ohb.ohb32,
                            l_ohbi.ohbiicd029,l_ohbi.ohbiicd028,'') 
                RETURNING l_flag
             IF l_flag = 0 THEN
                LET g_success = 'N'
                RETURN
             END IF
           END IF
           CALL p200_sub_oha_update()
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

END FUNCTION

FUNCTION p200_sub_oha_tlf(p_unit,p_img10)
DEFINE p_unit     LIKE ima_file.ima25       ##單位
DEFINE p_img10    LIKE img_file.img10       #異動後數量
DEFINE l_sfb02    LIKE sfb_file.sfb02
DEFINE l_sfb03    LIKE sfb_file.sfb03
DEFINE l_sfb04    LIKE sfb_file.sfb04
DEFINE l_sfb22    LIKE sfb_file.sfb22
DEFINE l_sfb27    LIKE sfb_file.sfb27
DEFINE l_sta      LIKE type_file.num5  
DEFINE g_cnt      LIKE type_file.num5   
      
   IF b_ohb.ohb16 > 0 THEN 
      #----來源----
      LET g_tlf.tlf01=b_ohb.ohb04             #異動料件編號
      LET g_tlf.tlf02=731
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '            #倉庫
      LET g_tlf.tlf022=' '            #儲位
      LET g_tlf.tlf023=' '            #批號
      LET g_tlf.tlf024=0              #異動後數量
      LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_oha.oha01    #銷退單號
      LET g_tlf.tlf027=b_ohb.ohb03    #銷退項次
      #---目的----
      LET g_tlf.tlf03=50
      LET g_tlf.tlf030=b_ohb.ohb08
      LET g_tlf.tlf031=b_ohb.ohb09    #倉庫
      LET g_tlf.tlf032=b_ohb.ohb091   #儲位
      LET g_tlf.tlf033=b_ohb.ohb092   #批號
      LET g_tlf.tlf034=p_img10        #異動後庫存數量
      LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_oha.oha01    #銷退單號
      LET g_tlf.tlf037=b_ohb.ohb03    #銷退項次
   ELSE
      #----來源----
      LET g_tlf.tlf01=b_ohb.ohb04        #異動料件編號
      LET g_tlf.tlf02=50
      LET g_tlf.tlf020=b_ohb.ohb08
      LET g_tlf.tlf021=b_ohb.ohb09       #倉庫
      LET g_tlf.tlf022=b_ohb.ohb091      #儲位
      LET g_tlf.tlf023=b_ohb.ohb092      #批號
      LET g_tlf.tlf024=p_img10           #異動後數量
      LET g_tlf.tlf025=p_unit            #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_oha.oha01       #銷退單號
      LET g_tlf.tlf027=b_ohb.ohb03       #銷退項次
      #---目的----
      LET g_tlf.tlf03=724
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '               #倉庫
      LET g_tlf.tlf032=' '               #儲位
      LET g_tlf.tlf033=' '               #批號
      LET g_tlf.tlf034=0                 #異動後庫存數量
      LET g_tlf.tlf035=' '               #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_oha.oha01       #銷退單號
      LET g_tlf.tlf037=b_ohb.ohb03       #銷退項次
   END IF	
   
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=ABS(b_ohb.ohb12) #異動數量
   LET g_tlf.tlf11=b_ohb.ohb05      #發料單位
   LET g_tlf.tlf12 =b_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=b_ohb.ohb50      #異動原因  
   LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=g_oha.oha01    #銷退單號
   LET g_tlf.tlf027=b_ohb.ohb03    #銷退項次

   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(b_ohb.ohb04) RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=g_oha.oha03
   LET g_sql ="SELECT oga46 FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
              " WHERE oga01 ='",b_ohb.ohb31,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE oga46_pre2 FROM g_sql
   EXECUTE oga46_pre2 INTO g_tlff.tlff20

   LET g_tlf.tlf61  = g_ima86
   LET g_tlf.tlf62  = b_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64  = b_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930 = b_ohb.ohb930 

   IF NOT cl_null(b_ohb.ohb31) THEN  #FUN-BB0130 add
      LET g_sql ="SELECT ogb41,ogb42,ogb43,ogb1001 FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                 " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03 ='",b_ohb.ohb32,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 						
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE ogb41_pre2 FROM g_sql
      EXECUTE ogb41_pre2 INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
   
      IF SQLCA.sqlcode THEN
         LET g_tlf.tlf20 = ' '
         LET g_tlf.tlf41 = ' '
         LET g_tlf.tlf42 = ' '
         LET g_tlf.tlf43 = ' '
      END IF
   ELSE
      LET g_tlf.tlf20 = ' '
      LET g_tlf.tlf41 = ' '
      LET g_tlf.tlf42 = ' '
      LET g_tlf.tlf43 = ' '
   END IF
   CALL s_tlf2(1,0,g_azw01)
END FUNCTION

FUNCTION p200_sub_oha_update()
DEFINE l_qty         LIKE img_file.img10
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_ima25       LIKE ima_file.ima25
DEFINE p_img         RECORD like img_file.*
DEFINE l_img         RECORD
        img01        LIKE img_file.img01,  
        img10        LIKE img_file.img10,
        img16        LIKE img_file.img16,
        img23        LIKE img_file.img23,
        img24        LIKE img_file.img24,
        img09        LIKE img_file.img09,
        img21        LIKE img_file.img21
                     END RECORD
DEFINE l_cnt         LIKE type_file.num5          
DEFINE l_ima71       LIKE ima_file.ima71
DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
DEFINE l_occ31       LIKE occ_file.occ31
DEFINE l_adq06       LIKE adq_file.adq06
DEFINE l_adq09       LIKE adq_file.adq09
DEFINE l_adp05       LIKE adp_file.adp05
DEFINE l_adp06       LIKE adp_file.adp06
DEFINE l_adq07       LIKE adq_file.adq07
DEFINE li_adq07      LIKE adq_file.adq07
DEFINE l_tuq06       LIKE tuq_file.tuq06                                           
DEFINE l_tuq09       LIKE tuq_file.tuq09                                           
DEFINE l_tup05       LIKE tup_file.tup05                                           
DEFINE l_tup06       LIKE tup_file.tup06                                           
DEFINE l_tup08       LIKE tup_file.tup08                                           
DEFINE l_tuq07       LIKE tuq_file.tuq07                                           
DEFINE li_tuq07      LIKE tuq_file.tuq07                                           
DEFINE l_tuq11       LIKE tuq_file.tuq11                                           
DEFINE l_tuq12       LIKE tuq_file.tuq12      
DEFINE l_desc        LIKE type_file.chr1       
DEFINE i             LIKE type_file.num5      
DEFINE l_count       LIKE type_file.num5 
DEFINE l_tup05_1     LIKE tup_file.tup05 
DEFINE l_tuq07_1     LIKE tuq_file.tuq07 
DEFINE l_tuq09_1     LIKE tuq_file.tuq09
DEFINE l_adq07_1     LIKE adq_file.adq07
DEFINE l_adq09_1     LIKE adq_file.adq09 

   IF s_joint_venture( b_ohb.ohb04,g_plant_new) OR NOT s_internal_item( b_ohb.ohb04,g_plant_new) THEN
      RETURN
   END IF
   LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'),
               " WHERE img01 = '",b_ohb.ohb04,"'",
               "   AND img02 = '",b_ohb.ohb09,"'",
               "   AND img03 = '",b_ohb.ohb091,"'",
               "   AND img04 = '",b_ohb.ohb092,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql ,g_plant_new) RETURNING g_sql
   PREPARE sel_img_cnt FROM g_sql
   EXECUTE sel_img_cnt INTO l_count
   IF l_count = 0 THEN
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=b_ohb.ohb04
      LET p_img.img02=b_ohb.ohb09
      LET p_img.img03=b_ohb.ohb091
      LET p_img.img04=b_ohb.ohb092
      LET p_img.img09=b_ohb.ohb05
      LET p_img.img10=0
      LET p_img.img21=1
      LET p_img.img23='Y'
      LET p_img.img24='N'
      LET b_ohb.ohb15=b_ohb.ohb05
      LET p_img.imgplant = g_plant_new
      SELECT azw02 INTO p_img.imglegal FROM azw_file WHERE azw01 = g_plant_new
      IF cl_null(p_img.imglegal) THEN
          LET  p_img.imglegal = ' '
      END IF
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",p_img.img01,"/",p_img.img02,"/",p_img.img03,"/",p_img.img04      
         CALL s_errmsg('azw01,oha98,img01,img02,img03,img04',g_msg,' oha_post(ins img):','axm-186',1)
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_errno='axm-186'                           
         LET g_msg1='img_file'||'ins'||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
   END IF
   
   IF cl_null(b_ohb.ohb09)  THEN LET b_ohb.ohb09=' ' END IF
   IF cl_null(b_ohb.ohb091) THEN LET b_ohb.ohb091=' ' END IF
   IF cl_null(b_ohb.ohb092) THEN LET b_ohb.ohb092=' ' END IF

   LET g_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21",
                      "  FROM ",cl_get_target_table(g_plant_new,'img_file'),
                      " WHERE img01= ? AND img02= ? AND img03= ? ",
                      "   AND img04= ?  FOR UPDATE "                    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql                   							
   CALL cl_parse_qry_sql(g_forupd_sql ,g_plant_new) RETURNING g_forupd_sql
   DECLARE img_lock_oha CURSOR FROM g_forupd_sql
   OPEN img_lock_oha USING b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092
   IF STATUS THEN
      LET g_errno=STATUS                           
      LET g_msg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04,"/",b_ohb.ohb09,"/",b_ohb.ohb091,"/",b_ohb.ohb092 
      CALL s_errmsg('azw01,oha98,img01,img02,img03,img04',g_msg,' oha_post(OPEN img_lock_oha):',STATUS,1)  
      LET g_success='N' 
      ROLLBACK WORK
      LET g_msg1='img_file'||'lock img fail'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
 
   FETCH img_lock_oha INTO l_img.*
   IF STATUS THEN
      LET g_errno=STATUS                           
      LET g_msg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04,"/",b_ohb.ohb09,"/",b_ohb.ohb091,"/",b_ohb.ohb092 
      CALL s_errmsg('azw01,oha98,img01,img02,img03,img04',g_msg,' oha_post(FETCH img_lock_oha):',STATUS,1)  
      LET g_success='N'
      ROLLBACK WORK
      LET g_msg1='img_file'||'lock img fail'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 + b_ohb.ohb16
  #FUN-C80068 Mark&Add Begin ---
  #IF b_ohb.ohb16 < 0 THEN 
  #   CALL s_mupimg('1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,b_ohb.ohb16,g_today,
  #         g_azw01,'',b_ohb.ohb01,b_ohb.ohb03)         
  #ELSE 
  #   CALL s_mupimg('-1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,(-1)*b_ohb.ohb16,g_today,
  #         g_azw01,'',b_ohb.ohb01,b_ohb.ohb03)  
  #END IF 	      

   IF b_ohb.ohb16 < 0 THEN
      CALL s_mupimg('1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,b_ohb.ohb16,g_today,
            g_azw01,1,b_ohb.ohb01,b_ohb.ohb03)
   ELSE
      CALL s_mupimg('-1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,(-1)*b_ohb.ohb16,g_today,
            g_azw01,-1,b_ohb.ohb01,b_ohb.ohb03)
   END IF
  #FUN-C80068 Mark&Add End -----
   IF g_success='N' THEN
      LET g_msg = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oha98',g_msg,' oha_post(s_upimg):','9050',1) 
      RETURN  
   END IF

   LET g_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE"     
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock_oha CURSOR FROM g_forupd_sql
   OPEN ima_lock_oha USING b_ohb.ohb04
   IF STATUS THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04
      CALL s_errmsg('azw01,oha98,ima01',g_msg,' oha_post(OPEN ima_lock_oha):',STATUS,1)       
      LET g_success='N' 
      LET g_errno=STATUS                           
      ROLLBACK WORK
      LET g_msg1='ima_file'||'lock ima fail'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   FETCH ima_lock_oha INTO l_ima25,g_ima86
   IF STATUS THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04
      CALL s_errmsg('azw01,oha98,ima01',g_msg,' oha_post(FETCH ima_lock_oha):',STATUS,1) 
      LET g_success='N' 
      LET g_errno=STATUS                           
      ROLLBACK WORK
      LET g_msg1='ima_file'||'lock ima fail'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN    
   END IF
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   IF b_ohb.ohb16 < 0 THEN             
      CALL s_udima1(b_ohb.ohb04,l_img.img23,l_img.img24,b_ohb.ohb16*l_img.img21,
                   g_oha.oha02,+1,g_azw01)  RETURNING l_cnt
        #最近一次發料日期 表發料  
   ELSE
      CALL s_udima1(b_ohb.ohb04,l_img.img23,l_img.img24,(-1)*b_ohb.ohb16*l_img.img21,
                   g_oha.oha02,-1,g_azw01)  RETURNING l_cnt
   END IF 	
   IF l_cnt THEN
      LET g_errno = SQLCA.SQLCODE
      LET g_msg = g_plant_new,"/",g_fno
      CALL s_errmsg('azw01,oha98',g_msg,' oha_post(s_udima1):',SQLCA.SQLCODE,1) 
      LET g_success='N'                   
      ROLLBACK WORK
      LET g_msg1='ima_file'||'Update Faile'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
   IF g_success='Y' THEN
      CALL p200_sub_oha_tlf(l_ima25,l_qty)
   END IF
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql ="SELECT occ31 FROM ",cl_get_target_table(g_plant_new,'occ_file'),
              " WHERE occ01 ='",g_oha.oha03,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE occ31_pre FROM g_sql
   EXECUTE occ31_pre INTO l_occ31
   LET g_sql ="SELECT ima25,ima71 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
              " WHERE ima01 ='",b_ohb.ohb04,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 						
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
   PREPARE ima25_pre FROM g_sql
   EXECUTE ima25_pre INTO l_ima25,l_ima71

   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
  #LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'adq_file'), 
  #           " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
  #           " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql 						
  #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #PREPARE adq_pre2 FROM g_sql
  #EXECUTE adq_pre2 INTO i
  #IF i=0 THEN
  #   LET l_fac1=1
  #   IF b_ohb.ohb05 <> l_ima25 THEN
  #      CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_ima25,g_azw01)
  #           RETURNING l_cnt,l_fac1
  #      IF l_cnt = '1'  THEN
  #         CALL s_errmsg('shop,fno',g_fno,b_ohb.ohb04,'abm-731',0)  
  #         LET l_fac1=1
  #      END IF
  #   END IF

  #   LET l_adq09=b_ohb.ohb12*l_fac1*-1
  #   LET l_adq09 = s_digqty(l_adq09,l_ima25)
  #   LET li_adq07=b_ohb.ohb12*-1
  #   LET li_adq07 = s_digqty(li_adq07,b_ohb.ohb05)
  #   LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'adq_file'),"(",
  #              "adq01,adq02,adq03,adq04,adq05,adq06,adq07,adq08,adq09,adq10) ",
  #              " VALUES(?,?,?,?,?,?,?,?,?,?) "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 							
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #   PREPARE adq_pre FROM g_sql
  #   EXECUTE adq_pre USING  g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,g_oha.oha02,g_oha.oha01,
  #                          b_ohb.ohb05,li_adq07,l_fac1,l_adq09,'2'
  #   
  #   IF SQLCA.sqlcode THEN
  #      LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
  #      LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02         
  #      CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'insert adq_file',SQLCA.sqlcode,1)
  #      LET g_success ='N'                  
  #      ROLLBACK WORK
  #      LET g_msg1='adq_file'||'insert adq_file'||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      RETURN
  #   END IF
  #ELSE
  #   LET g_sql ="SELECT UNIQUE adq06 FROM ",cl_get_target_table(g_plant_new,'adq_file'),
  #              " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
  #              " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 							
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #   PREPARE adq06_pre FROM g_sql
  #   EXECUTE adq06_pre INTO l_adq06
  #   IF SQLCA.sqlcode THEN
  #      LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
  #      CALL cl_err3("sel","adq_file",g_fno,g_plant_new,SQLCA.sqlcode,"","select adq06",1)  
  #      LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02      
  #      CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'select adq06',SQLCA.sqlcode,1)
  #      LET g_success ='N'                   
  #      ROLLBACK WORK
  #      LET g_msg1='adq_file'||'select adq06'||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      RETURN
  #   END IF
  #   LET l_fac1=1

  #   IF b_ohb.ohb05 <> l_adq06 THEN
  #      CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_adq06,g_azw01)
  #           RETURNING l_cnt,l_fac1
  #      IF l_cnt = '1'  THEN
  #         CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0)  
  #         LET g_errno='abm-731'                      
  #         LET g_success = 'N'
  #         ROLLBACK WORK
  #         LET g_msg1=' '||b_ohb.ohb04||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         LET l_fac1=1
  #         RETURN
  #      END IF
  #   END IF
  #   LET g_sql ="SELECT adq07 FROM ",cl_get_target_table(g_plant_new,'adq_file'),
  #              " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
  #              " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #   PREPARE adq07_pre FROM g_sql
  #   EXECUTE adq07_pre INTO l_adq07
  #   
  #   IF cl_null(l_adq07) THEN LET l_adq07=0 END IF
  #   IF l_adq07-b_ohb.ohb12*l_fac1<0 THEN
  #      LET l_desc='2'
  #   ELSE
  #      LET l_desc='1'
  #   END IF
  #   IF l_adq07=b_ohb.ohb12*l_fac1 THEN
  #      LET g_sql ="DELETE FROM ",cl_get_target_table(g_plant_new,'adq_file'),
  #                 " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
  #                 " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #      PREPARE adq_del_pre FROM g_sql
  #      EXECUTE adq_del_pre
  #   
  #      IF SQLCA.sqlcode THEN
  #         LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
  #         LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02           
  #         CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)  
  #         LET g_success='N'               
  #         ROLLBACK WORK
  #         LET g_msg1='adq_file'||'delete adq_file'||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         RETURN
  #      END IF
  #   ELSE
  #      LET l_fac2=1
  #      IF l_adq06 <> l_ima25 THEN
  #         CALL s_umfchkm(b_ohb.ohb04,l_adq06,l_ima25,g_azw01)
  #              RETURNING l_cnt,l_fac2
  #         IF l_cnt = '1'  THEN
  #            CALL cl_err(b_ohb.ohb04,'abm-731',1)
  #            LET l_fac2=1
  #         END IF
  #      END IF
  #      LET l_adq07_1 = s_digqty(b_ohb.ohb12*l_fac1,l_ima25)
  #      LET l_adq09_1 = s_digqty(b_ohb.ohb12*l_fac1*l_fac2,l_adq06)
  #      LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'adq_file'), 
  #                 " SET adq07=adq07-",l_adq07_1,", ",
  #                 " adq09=adq09-",l_adq09_1,", ",
  #                 " adq10='",l_desc,"' ",
  #                 " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
  #                 " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #      PREPARE adq_upd_pre FROM g_sql
  #      EXECUTE adq_upd_pre
  #   
  #      IF SQLCA.sqlcode THEN
  #         LET g_errno = SQLCA.SQLCODE 
  #         LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02         
  #         CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)
  #         LET g_success='N'          
  #         ROLLBACK WORK
  #         LET g_msg1='adq_file'||'delete adq_file'||g_plant_new||g_fno
  #         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #         LET g_msg=g_msg[1,255]
  #         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #         LET g_errno=''
  #         LET g_msg=''
  #         LET g_msg1=''
  #         RETURN
  #      END IF
  #   END IF
  #END IF
  #LET l_fac1=1
  #IF b_ohb.ohb05 <> l_ima25 THEN
  #   CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_ima25,g_azw01)
  #        RETURNING l_cnt,l_fac1
  #   IF l_cnt = '1'  THEN
  #      CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0)  
  #      LET g_errno='abm-731'                      
  #      LET g_success = 'N'
  #      ROLLBACK WORK
  #      LET g_msg1=' '||b_ohb.ohb04||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      LET l_fac1=1
  #      RETURN
  #   END IF
  #END IF
  #LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'adp_file'),
  #           " WHERE adp01 ='",g_oha.oha03,"' AND adp02='",b_ohb.ohb04,"' ",
  #           " AND adp03='",b_ohb.ohb092,"' "
  #CALL cl_replace_sqldb(g_sql) RETURNING g_sql  						
  #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  #PREPARE adp_sel_pre FROM g_sql
  #EXECUTE adp_sel_pre INTO i

  #IF i=0 THEN
  #   LET l_adp05=b_ohb.ohb12*l_fac1*-1
  #   LET l_adp06=l_ima71+g_oha.oha02
  #   LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'adp_file'), "(",
  #              "adp01,adp02,adp03,adp04,adp05,adp06,adp07) ",
  #              " VALUES(?,?,?,?,?,?,?) "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #   PREPARE adp_pre FROM g_sql
  #   EXECUTE adp_pre USING g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,l_ima25,
  #                         l_adp05,l_adp06,g_oha.oha02
  #   IF SQLCA.sqlcode THEN
  #      LET g_errno = SQLCA.SQLCODE
  #      LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092                       
  #      CALL s_errmsg('shop,fno,adp01,adp02,adp03',g_showmsg,'insert adp_file',SQLCA.sqlcode,1)    
  #      LET g_success='N'           
  #      ROLLBACK WORK
  #      LET g_msg1='adp_file'||'insert adp_file'||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      RETURN
  #   END IF
  #ELSE
  #   LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'adp_file'),
  #              " SET adp05=adp05-",b_ohb.ohb12*l_fac1,
  #              " WHERE adp01 ='",g_oha.oha03,"' AND adp02='",b_ohb.ohb04,"' ",
  #              " AND adp03='",b_ohb.ohb092,"' "
  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
  #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  #   PREPARE adp_upd_pre FROM g_sql
  #   EXECUTE adp_upd_pre
  #
  #   IF SQLCA.sqlcode THEN
  #      LET g_errno = SQLCA.SQLCODE 
  #      LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092                  
  #      CALL s_errmsg('shop,fno,adp01,adp02,adp03',g_showmsg,'update adp_file',SQLCA.sqlcode,1)
  #      LET g_success='N'          
  #      ROLLBACK WORK
  #      LET g_msg1='adp_file'||'update adp_file'||g_plant_new||g_fno
  #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
  #      LET g_msg=g_msg[1,255]
  #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
  #      LET g_errno=''
  #      LET g_msg=''
  #      LET g_msg1=''
  #      RETURN
  #   END IF
  #END IF
END FUNCTION

FUNCTION p200_sub_oha_bu1()                             #更新出貨單銷退量 & 訂單銷退量
DEFINE l_ogb04   LIKE ogb_file.ogb04
DEFINE l_oeb25   LIKE oeb_file.oeb25
DEFINE l_a       LIKE type_file.chr1   

   CALL cl_msg("bu!")
   IF g_oha.oha09 = '1' THEN RETURN END IF

   IF NOT cl_null(b_ohb.ohb31) THEN                     #更新出貨單銷退量
      LET g_sql ="SELECT SUM(ohb12) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",",
                                           cl_get_target_table(g_plant_new,'oha_file'),
                 " WHERE ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32,
                 " AND ohb01=oha01 AND ohapost='Y' AND oha09='2' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE ohb12_sum_pre2 FROM g_sql
      EXECUTE ohb12_sum_pre2 INTO tot1
      LET g_sql ="SELECT SUM(ohb12) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",",
                                           cl_get_target_table(g_plant_new,'oha_file'),
                 " WHERE ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32,
                 " AND ohb01=oha01 AND ohapost='Y' AND oha09='3' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql     
      PREPARE ohb12_sum_pre3 FROM g_sql
      EXECUTE ohb12_sum_pre3 INTO tot2

      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF

      LET g_chr='N'
      LET g_sql ="SELECT ogb04 FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                 " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 					
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE ogb04_pre2 FROM g_sql
      EXECUTE ogb04_pre2 INTO l_ogb04

      IF b_ohb.ohb04 = l_ogb04 THEN      #銷退品號與出貨品號相同才update
         LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'ogb_file'),
                   #" SET ogb63='",tot1,"' AND ogb64=",tot2, #FUN-C80079 Mark
                    "   SET ogb63 = ",tot1,                  #FUN-C80079 Add #財務要求
                    " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  					
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE ogb63_pre2 FROM g_sql
         EXECUTE ogb63_pre2 

         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_errno=STATUS                   
            LET g_msg = g_plant_new,"/",g_fno,"/",b_ohb.ohb31,"/",b_ohb.ohb32                     
            CALL s_errmsg('azw01,oha98,ogb01,ogb03',g_msg,' oha_post(upd ogb63,64):',STATUS,1) 
            LET g_success = 'N' 
            ROLLBACK WORK
            LET g_msg1='ogb_file'||'upd ogb63,64'||g_plant_new||g_fno
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
      END IF
   END IF
   IF g_oha.oha09 != '4' THEN RETURN END IF     

END FUNCTION

FUNCTION p200_sub_oha_y1()
DEFINE s_ohb12 LIKE ohb_file.ohb12
DEFINE l_slip   LIKE oay_file.oayslip
DEFINE l_oay13  LIKE oay_file.oay13
DEFINE l_oay14  LIKE oay_file.oay14
DEFINE l_ohb14t LIKE ohb_file.ohb14t
   
   LET l_slip = s_get_doc_no(g_oha.oha01)
   LET g_sql ="SELECT oay13,oay14 FROM ",cl_get_target_table(g_plant_new,'oay_file'),
              " WHERE oayslip ='",l_slip,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE oay_pre FROM g_sql
   EXECUTE oay_pre INTO l_oay13,l_oay14
   IF l_oay13 = 'Y' AND g_oha.oha09 MATCHES '[145]' THEN
      LET g_sql ="SELECT SUM(ohb14t) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                 " WHERE ohb01 ='",g_oha.oha01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  						
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE ohb14t_sum_pre2 FROM g_sql
      EXECUTE ohb14t_sum_pre2 INTO l_ohb14t
      IF cl_null(l_ohb14t) THEN LET l_ohb14t = 0 END IF
      LET l_ohb14t = l_ohb14t * g_oha.oha24
      IF l_ohb14t > l_oay14 THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",l_oay14
         CALL s_errmsg('azw01,oha98,oay14',g_msg,' oha_post(chk ohb14t):','axm-700',1)
         LET g_success='N' 
         ROLLBACK WORK
         LET g_errno = 'axm-700'
         LET g_msg1=' '||' '||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
   END IF
   
   # check 銷退量及出貨量的控管
   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), 
              " WHERE ohb01 ='",g_oha.oha01,"' ",
              " AND (ohb1005='1' OR ohb1005 IS NULL) AND (ohb1004='N' OR ohb1004 IS NULL) ORDER BY ohb03 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql						
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p200_y1_c_pre FROM g_sql
   DECLARE p200_y1_c CURSOR FOR p200_y1_c_pre
   FOREACH p200_y1_c INTO b_ohb.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF
      
      IF STATUS THEN
         LET g_errno=STATUS                   
         LET g_msg = g_plant_new,"/",g_fno
         CALL s_errmsg('azw01,oha98',g_msg,' oha_post(FOREACH p200_y1_c):',STATUS,1)
         LET g_success = 'N' 
         ROLLBACK WORK
         LET g_msg1='ohb_file'||'y1 foreach'||g_plant_new||g_fno
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      LET g_cmd='_y1() read ohb:',b_ohb.ohb03
      CALL cl_msg(g_cmd)
      IF NOT cl_null(b_ohb.ohb31) THEN
         LET g_sql ="SELECT SUM(ohb12),SUM(ohb14t),SUM(ohb14) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",",
                                                                     cl_get_target_table(g_plant_new,'oha_file'),
                    " WHERE oha01=ohb01 AND ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32," AND ohaconf='Y' " 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql 					
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE ohb12t_pre FROM g_sql
         EXECUTE ohb12t_pre INTO l_ohb12,l_ohb14t,l_ohb14
         LET g_sql ="SELECT SUM(ogb12),SUM(ogb14t),SUM(ogb14) FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",
                                                                     cl_get_target_table(g_plant_new,'ogb_file'),
                    " WHERE oga01=ogb01 AND ogb01='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32  
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  						
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE ogb12t_pre FROM g_sql
         EXECUTE ogb12t_pre INTO l_ogb12,l_ogb14t,l_ogb14
      
         IF cl_null(l_ohb12 ) THEN LET l_ohb12 =0 END IF
         IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
         IF cl_null(l_ohb14 ) THEN LET l_ohb14 =0 END IF
         IF cl_null(l_ogb12 ) THEN LET l_ogb12 =0 END IF
         IF cl_null(l_ogb14t) THEN LET l_ogb14t=0 END IF
         IF cl_null(l_ogb14 ) THEN LET l_ogb14 =0 END IF
         IF l_ogb12 - l_ohb12 <0 THEN
            LET s_ohb12=l_ohb12-b_ohb.ohb12
            IF cl_null(s_ohb12) THEN LET s_ohb12=0 END IF
            CALL cl_getmsg('axr-267',g_lang) RETURNING l_msg1
            CALL cl_getmsg('axr-274',g_lang) RETURNING l_msg2
            CALL cl_getmsg('axr-268',g_lang) RETURNING l_msg3
            LET g_msg1=l_msg1 CLIPPED,s_ohb12 USING '######&.##','+',
                       l_msg2 CLIPPED,b_ohb.ohb12 USING '######&.##',
                       l_msg3 CLIPPED
            CALL cl_getmsg('axr-266',g_lang) RETURNING l_msg1
            LET g_msg1=g_msg CLIPPED,
                       l_msg1 CLIPPED,l_ogb12 USING '######&.##'
            LET g_msg = g_plant_new,"/",g_fno
            CALL s_errmsg('azw01,oha98',g_msg,g_msg1,'aap-999',1) 
            LET g_success='N' 
            ROLLBACK WORK
            LET g_errno='aap-999'                   
            LET g_msg1=' '||g_msg1||g_plant_new||g_fno
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
         IF l_ohb14 > l_ohb14t THEN
            #若超過金額只警告不拒絕
            IF l_ogb14 - l_ohb14 <0 THEN
              CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
              CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
              CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
              LET g_msg1=l_msg1 CLIPPED,l_ohb14t-b_ohb.ohb14t USING '#####&.##','+',
                         l_msg2 CLIPPED,b_ohb.ohb14t USING '#####&.##','>',
                         l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
            END IF
         ELSE
            IF l_ogb14t - l_ohb14t <0 THEN
               CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
               CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
               CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
               LET g_msg1=l_msg1 CLIPPED,l_ohb14t-b_ohb.ohb14t USING '#####&.##','+',
                         l_msg2 CLIPPED,b_ohb.ohb14t USING '#####&.##','>',
                         l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
               IF NOT cl_confirm2('axr-284',g_msg1) THEN
                  LET g_success='N' CONTINUE FOREACH   
               END IF
            END IF
         END IF
      END IF
      IF g_success='N' THEN CONTINUE FOREACH END IF  
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
END FUNCTION


#Note:原sapcp200_pmk.4gl
FUNCTION t420sub_y_chk(p_pmk01,p_plant)
DEFINE p_pmk01       LIKE pmk_file.pmk01
DEFINE p_plant       LIKE azp_file.azp01
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_str         LIKE type_file.chr4
DEFINE l_pml04       LIKE pml_file.pml04
DEFINE l_pml33       LIKE pml_file.pml33
DEFINE l_pml35       LIKE pml_file.pml35
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ima140      LIKE ima_file.ima140
DEFINE l_ima1401     LIKE ima_file.ima1401
DEFINE l_pmk         RECORD LIKE pmk_file.*
DEFINE l_status      LIKE type_file.chr1
DEFINE l_t1          LIKE smy_file.smyslip
 
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs CLIPPED)
   LET g_success = 'Y'
   IF p_pmk01 IS NULL THEN RETURN END IF 
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'pmk_file'), 
               "  WHERE pmk01='",p_pmk01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_pmk_pre FROM g_sql
   EXECUTE sel_pmk_pre INTO l_pmk.*
   IF l_pmk.pmk18='X' THEN                    #當確認碼為 'X' 作廢時, RETURN
        LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01
        CALL s_errmsg("azw01,oea94,pmk01",g_msg," pmk_confirm(chk pmk18):","9024",1) 
        LET g_errno='9024'                           
        LET g_success = 'N'
        ROLLBACK WORK
	LET g_msg1=' '||'pmk01'||g_plant_new||g_fno1
	CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	LET g_msg=g_msg[1,255]
	CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	LET g_errno=''
	LET g_msg=''
	LET g_msg1=''
        RETURN
   END IF
   IF l_pmk.pmkacti='N' THEN                  #當資料有效碼為 'N' 時, RETURN
        LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01
        CALL s_errmsg("azw01,oea94,pmk01",g_msg," pmk_confirm(chk pmkacti):","mfg0301",1)
        LET g_errno='mfg0301'                           
        LET g_success = 'N'
        ROLLBACK WORK
	LET g_msg1=' '||'pmk01'||g_plant_new||g_fno1
	CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	LET g_msg=g_msg[1,255]
	CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	LET g_errno=''
	LET g_msg=''
	LET g_msg1=''
        RETURN
   END IF
 
   LET l_cnt = 0
   LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'pml_file'), 
               "  WHERE pml01='",l_pmk.pmk01,"' AND pml33 IS NULL"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_pml_pre2 FROM g_sql
   EXECUTE sel_pml_pre2 INTO l_cnt
   IF l_cnt >=1 THEN
      #單身交貨日期尚有資料是空白的,請補齊.
         LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01
         CALL s_errmsg("azw01,oea94,pmk01",g_msg," pmk_confirm(chk pml_file):","apm-421",1) 
         LET g_errno='apm-421'                           
         LET g_success = 'N'
         ROLLBACK WORK
	 LET g_msg1=' '||'pmk01'||g_plant_new||g_fno1
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         RETURN
   END IF
   LET g_sql = " SELECT pml04,pml33,pml35 FROM ",cl_get_target_table(g_plant_new,'pml_file'), 
               " WHERE pml01 = '",l_pmk.pmk01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   DECLARE pml_cur1 CURSOR FROM g_sql
    FOREACH pml_cur1 INTO l_pml04,l_pml33,l_pml35 				
       IF g_success="N" THEN
          LET g_totsuccess="N"
          LET g_success="Y"
       END IF
       LET l_str = l_pml04[1,4]  
       IF l_str = 'MISC' THEN CONTINUE FOREACH END IF 
       SELECT imaacti,ima140,ima1401 INTO l_imaacti,l_ima140,l_ima1401  
         FROM ima_file
        WHERE ima01 = l_pml04
       IF SQLCA.sqlcode THEN
          IF l_pml04[1,4] <>'MISC' THEN  
              LET l_imaacti = 'N'
              LET l_ima140 = 'Y'
          END IF
       END IF
       IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmk.pmk04) THEN   
          LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01,"/",l_pml04
          CALL s_errmsg("azw01,oea94,pmk01,pml04",g_msg," pmk_confirm(chk pml04):","apm-006",1) 
          LET g_errno='apm-006'                           
          LET g_success = 'N'
          ROLLBACK WORK
          LET g_msg1=' '||'pml04'||g_plant_new||g_fno1
          CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
          LET g_msg=g_msg[1,255]
          CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
          LET g_errno=''
          LET g_msg=''
          LET g_msg1=''
       END IF
       IF l_pml33 < l_pmk.pmk04 THEN
          LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01,"/",l_pml33
          CALL s_errmsg("azw01,oea94,pmk01,pml33",g_msg," pmk_confirm(chk pml33):","apm-027",1)    
          LET g_success = 'N'
          LET g_errno='apm-027'                           
          ROLLBACK WORK
	  LET g_msg1=' '||'pml33'||g_plant_new||g_fno1
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          RETURN
       END IF       
       IF l_pml35 < l_pmk.pmk04 THEN
          LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01,"/",l_pml35
          CALL s_errmsg("azw01,oea94,pmk01,pml35",g_msg," pmk_confirm(chk pml35):","apm-060",1)    
          LET g_success = 'N'
          LET g_errno='apm-060'                           
          ROLLBACK WORK
	  LET g_msg1=' '||'pml35'||g_plant_new||g_fno1
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          RETURN
       END IF       
    END FOREACH
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
END FUNCTION

FUNCTION t420sub_lock_cl()
DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'pmk_file'),
                      " WHERE pmk01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql
   CALL cl_parse_qry_sql(l_forupd_sql,g_plant_new) RETURNING l_forupd_sql
   DECLARE t420sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

FUNCTION t420sub_y_upd(p_pmk01,p_action_choice,p_plant,p_oeb03)
DEFINE p_pmk01         LIKE pmk_file.pmk01
DEFINE p_action_choice STRING
DEFINE l_pmk           RECORD LIKE pmk_file.*
DEFINE l_pmkmksg       LIKE pmk_file.pmkmksg
DEFINE l_pmk25         LIKE pmk_file.pmk25          
DEFINE p_plant         LIKE azp_file.azp01
DEFINE p_oeb03         LIKE oeb_file.oeb03
 
   WHENEVER ERROR CONTINUE
 
   LET g_success = 'Y'
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs CLIPPED)
 
   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      p_action_choice CLIPPED = "insert" 
   THEN 
      SELECT pmkmksg,pmk25 
        INTO l_pmkmksg,l_pmk25
        FROM pmk_file
       WHERE pmk01=p_pmk01
      IF l_pmkmksg='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_pmk25 != '1' THEN
            LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk01,"/",l_pmk25
            CALL s_errmsg('azw01,oea94,pmk01,pmk25',g_msg,' pmk_confirm(chk pmk25):','aws-078',1)
            LET g_success = 'N'
            LET g_errno = 'aws-078'
            ROLLBACK WORK
            LET g_msg1=' '||' '||g_plant_new||g_fno1
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN 
         LET g_success = 'N'     
         RETURN 
      END IF  #詢問是否執行確認功能
   END IF
 
 
   CALL t420sub_lock_cl() 
   OPEN t420sub_cl USING p_pmk01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t420sub_cl:", STATUS, 1)
      CLOSE t420sub_cl
      RETURN
   END IF
 
   FETCH t420sub_cl INTO l_pmk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_pmk.pmk01,SQLCA.sqlcode,0)
      CLOSE t420sub_cl
      RETURN
   END IF 
   CALL t420sub_y1(l_pmk.*)
 
   IF g_success = 'Y' THEN
      IF g_azw.azw04 = '2' THEN
         CALL t420sub_transfer(l_pmk.*,p_plant,p_oeb03) 
      END IF
      IF g_success='Y' THEN
         LET l_pmk.pmk25='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET l_pmk.pmk18='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         CALL cl_flow_notify(l_pmk.pmk01,'Y')
      ELSE
         LET l_pmk.pmk18='N'
         LET g_success = 'N'
      END IF
   ELSE
      LET l_pmk.pmk18='N'
      LET g_success = 'N'
   END IF
 
END FUNCTION

FUNCTION t420sub_budchk(p_pmk)
DEFINE p_pmk     RECORD LIKE pmk_file.*
DEFINE l_pml     RECORD LIKE pml_file.*
DEFINE l_bud     LIKE type_file.num5
DEFINE over_amt  LIKE pml_file.pml44
DEFINE last_amt  LIKE pml_file.pml44
DEFINE l_msg     LIKE ze_file.ze03  
DEFINE l_bud1    LIKE type_file.num5
DEFINE l_msg1    LIKE ze_file.ze03
DEFINE over_amt1 LIKE pml_file.pml44 
DEFINE last_amt1 LIKE pml_file.pml44
DEFINE p_sum1    LIKE afc_file.afc07
DEFINE p_sum2    LIKE afc_file.afc07
DEFINE l_flag    LIKE type_file.num5
DEFINE l_over    LIKE afc_file.afc07
DEFINE l_yy      LIKE type_file.num5
DEFINE l_mm      LIKE type_file.num5
DEFINE l_bookno1 LIKE aaa_file.aaa01
DEFINE l_bookno2 LIKE aaa_file.aaa01
DEFINE l_afb07   LIKE afb_file.afb07
 
   DECLARE bud_cur CURSOR FOR
      SELECT * FROM pml_file WHERE pml01=p_pmk.pmk01
 
   FOREACH bud_cur INTO l_pml.*
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
      IF g_aza.aza08 = 'N' THEN
         LET l_pml.pml12 = ' '
         LET l_pml.pml121= ' '
      END IF
      CALL s_get_bookno(YEAR(p_pmk.pmk31)) RETURNING l_flag,l_bookno1,l_bookno2   
      LET p_sum1 = l_pml.pml87 * l_pml.pml44
      LET p_sum2 = l_pml.pml87 * l_pml.pml44
      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
      LET l_yy = p_pmk.pmk31
      LET l_mm = p_pmk.pmk32
      IF g_aaz.aaz90 = 'Y' THEN
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                          l_yy,l_pml.pml121,
                          l_pml.pml930,l_pml.pml12,
                          l_mm,'0','a',0,p_sum2,'1')
      ELSE
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                          l_yy,l_pml.pml121,                 
                          l_pml.pml67,l_pml.pml12,                        
                          l_mm,'0','a',0,p_sum2,'1')
      END IF    
      IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
      IF g_aza.aza63 = 'Y' THEN
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'1','a',0,p_sum2,'1')
         ELSE
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'1','a',0,p_sum2,'1')
         END IF        
      END IF
      IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
      IF g_success = 'Y' THEN
         #同一筆單據中,有相同的預算資料
         #因為沒有確認..故耗用..會算不到其他單身中的金額,故此處卡總量
         SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   
          WHERE pml01 = l_pml.pml01
            AND pml90 = l_pml.pml90
            AND pml40 = l_pml.pml40
            AND pmk01 = pml01   
            AND pmk31 = l_yy   
            AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
            AND pml67 = l_pml.pml67
            AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
            AND pmk32 = l_mm   
         IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'0','a',0,p_sum1,'2')
         ELSE
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'0','a',0,p_sum1,'2')
         END IF      
         IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
         IF g_aza.aza63 = 'Y' THEN
            SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   
             WHERE pml01 = l_pml.pml01
               AND pml90 = l_pml.pml90
               AND pml401= l_pml.pml401
               AND pmk01 = pml01   
               AND pmk31 = l_yy   
               AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
               AND pml67 = l_pml.pml67
               AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
               AND pmk32 = l_mm   
            IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
            IF g_aaz.aaz90 = 'Y' THEN
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                                l_yy,l_pml.pml121,
                                l_pml.pml930,l_pml.pml12,
                                l_mm,'1','a',0,p_sum1,'2')
            ELSE
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                                l_yy,l_pml.pml121,                 
                                l_pml.pml67,l_pml.pml12,                        
                                l_mm,'1','a',0,p_sum1,'2')
            END IF      
            IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-C90011 Add
         END IF
      END IF
 
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
END FUNCTION

FUNCTION t420sub_y1(p_pmk)
DEFINE l_cmd         LIKE type_file.chr1000 
DEFINE l_str         LIKE type_file.chr4   
DEFINE l_pml         RECORD LIKE pml_file.*
DEFINE l_pml04       LIKE pml_file.pml04
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ima140      LIKE ima_file.ima140
DEFINE l_pml20       LIKE pml_file.pml20
DEFINE l_i           LIKE type_file.num5  
DEFINE l_cnt         LIKE type_file.num5 
DEFINE p_pmk         RECORD LIKE pmk_file.*
DEFINE l_pml24       LIKE pml_file.pml24
DEFINE l_pml25       LIKE pml_file.pml25
DEFINE l_pml87       LIKE pml_file.pml87
 
   IF p_pmk.pmkmksg='N' AND (p_pmk.pmk25='0' OR p_pmk.pmk25='X') THEN
      LET p_pmk.pmk25='1'
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'pml_file'), 
                  " SET pml16= '",p_pmk.pmk25,"'  ",
                  " WHERE pml01='",p_pmk.pmk01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE upd_pml16_pre FROM g_sql
      EXECUTE upd_pml16_pre
      IF STATUS THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk.pmk01
         CALL s_errmsg("azw01,oea94,pml01",g_msg," pmk_confirm(upd pml16):",STATUS,1)
         LET g_errno=STATUS                          
	 LET g_msg1='pml_file'||'upd pml16'||g_plant_new||g_fno1
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         LET g_success = 'N' 
         RETURN
      END IF
   END IF
 
   LET p_pmk.pmkcond=g_today
   LET p_pmk.pmkconu=g_user   
   LET p_pmk.pmkcont=TIME
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'pmk_file'), 
               " SET ",
               " pmk25='",p_pmk.pmk25,"', ",
               " pmkconu='",p_pmk.pmkconu,"', ",      
               " pmkcond='",p_pmk.pmkcond,"', ",      
               " pmkcont='",p_pmk.pmkcont,"', ",      
               " pmk18='Y'  ",
               "  WHERE pmk01 = '",p_pmk.pmk01,"' " 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE upd_pmk_pre FROM g_sql
   EXECUTE upd_pmk_pre
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk.pmk01
      CALL s_errmsg("azw01,oea94,pmk01",g_msg," pmk_confirm(upd pmk18):",STATUS,1)
      LET g_errno=STATUS                          
      LET g_success = 'N'
      ROLLBACK WORK
      LET g_msg1='pmk_file'||'upd pmk18'||g_plant_new||g_fno1
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   END IF
 
   #S/O拋P/R時，如P/R數量有更動要回寫到S/O
   
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), 
               " WHERE oeb01 = ?  AND oeb03 = ? FOR UPDATE" 
   LET g_sql=cl_forupd_sql(g_sql)
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   DECLARE t420y1_cl CURSOR FROM g_sql
 
   LET g_sql = "SELECT pml24,pml25,pml87 FROM ",cl_get_target_table(g_plant_new,'pml_file'), 
                                      " WHERE pml01='",p_pmk.pmk01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   DECLARE t420y2_cl CURSOR FROM g_sql
   FOREACH t420y2_cl INTO l_pml24,l_pml25,l_pml87
      IF SQLCA.sqlcode THEN
         LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk.pmk01
         CALL s_errmsg('azw01,oea94,pmk01',g_msg,' pmk_confirm(FOREACH t420y2_cl):',STATUS,1)
         LET g_errno = STATUS
         LET g_success='N'
         ROLLBACK WORK
         LET g_msg1=' '||' '||g_plant_new||g_fno1
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      OPEN t420y1_cl USING l_pml24,l_pml25 #check DB 是否被他人鎖定
      IF STATUS THEN
         LET g_errno = STATUS
         LET g_success = 'N'
         LET g_msg = g_plant_new,"/",g_fno,"/",p_pmk.pmk01
         CALL s_errmsg('azw01,oea94,pmk01',g_msg,' pmk_confirm(OPEN t420y1_cl):', STATUS, 1)
         CLOSE t420y1_cl
         LET g_msg1=' '||' '||g_plant_new||g_fno1
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      CLOSE t420y1_cl  #無被鎖定就可以CLOSE
      LET g_sql = " UPDATE oeb_file " ,
                  "   SET oeb28 = '",l_pml87,"' ",
                  " WHERE oeb01 = '",l_pml24,"' ",
                  "   AND oeb03 = '",l_pml25,"' "
      PREPARE upd_oeb_pre FROM g_sql
      EXECUTE upd_oeb_pre
   END FOREACH
END FUNCTION

FUNCTION t420sub_bud(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,
                     p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2,p_flag1)
DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
DEFINE p_afc04     LIKE afc_file.afc04  #WBS
DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
DEFINE p_afc05     LIKE afc_file.afc05  #期別
DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
DEFINE p_flag1     LIKE type_file.chr1  #1.單筆檢查 2.單身total檢查
DEFINE p_cmd       LIKE type_file.chr1
DEFINE p_sum1      LIKE afc_file.afc06 
DEFINE p_sum2      LIKE afc_file.afc06 
DEFINE l_flag      LIKE type_file.num5
DEFINE l_afb07     LIKE afb_file.afb07
DEFINE l_over      LIKE afc_file.afc07
DEFINE l_msg       LIKE ze_file.ze03
 
   CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,        
                  p_afc041,p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2)
       RETURNING l_flag,l_afb07,l_over
   IF l_flag = FALSE THEN
      LET g_success = 'N'
      LET g_msg = g_plant_new,'/',g_fno,'/',p_afc00,'/',p_afc01,'/',p_afc02,'/',
                  p_afc03 USING "<<<&",'/',p_afc04,'/',
                  p_afc041,'/',p_afc042,'/',
                  p_afc05 USING "<&",p_sum2,'/',l_over
      IF p_flag1 = '2' THEN
         LET g_errno = 'agl-232'
      END IF
      CALL s_errmsg('azw01,oea94,afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_msg,' pmk_confirm(s_budchk1):',g_errno,1)
      LET g_errno='agl-232'                         
      ROLLBACK WORK
      LET g_msg1='afc_file'||'t420sub_bud'||g_plant_new||g_fno1
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      RETURN
   ELSE
      IF l_afb07 = '2' AND l_over < 0 THEN
         IF p_flag1 = '2' THEN
            LET g_errno = 'agl-232'
         END IF
         LET g_msg = g_plant_new,'/',g_fno,'/',p_afc00,'/',p_afc01,'/',p_afc02,'/',
                     p_afc03 USING "<<<&",'/',p_afc04,'/',
                     p_afc041,'/',p_afc042,'/',
                     p_afc05 USING "<&",p_sum2,'/',l_over
         CALL s_errmsg('azw01,oea94,afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_msg,' pmk_confirm(chk afb07):',g_errno,1)
         LET g_errno='agl-232'                         
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_msg1='afc_file'||'t420sub_bud'||g_plant_new||g_fno1
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t420sub_transfer(p_pmk,p_plant,p_oeb03)
DEFINE l_ruc   RECORD LIKE ruc_file.*
DEFINE p_pmk   RECORD LIKE pmk_file.*
DEFINE l_flag  LIKE type_file.chr1
DEFINE l_rate  LIKE ruc_file.ruc17
DEFINE p_plant LIKE azw_file.azw01
DEFINE p_oeb03 LIKE oeb_file.oeb03
       
  #FUN-CC0082 Mark&Add Begin ---
  #LET g_sql="SELECT '','',pml01,pml02,pml04,'','','',pml24,pml25,pml48,pml49,pml50,'',",
  #          " pml47,pml041,pml07,'',pml20,'','','','',",
  #          " pml51,pml52,pml53,'',pml33,pml54,'',pml191,pml55 ",
  #          " FROM ",cl_get_target_table(g_plant_new,'pml_file'),
  #          " WHERE pml01='",p_pmk.pmk01,"'",
  #          " AND pml02='",p_oeb03,"'",
  #          " ORDER BY pml02 "
   LET g_sql="SELECT '','',pml01,pml02,pml04,'','','',pml24,pml25,pml48,pml49,pml50,'',", #ruc00 ~ ruc13
             " pml47,pml041,pml07,'',pml20,'','','','',",                                 #ruc14 ~ ruc22
             " pml51,pml52,pml53,'',pml33,pml54,'',pml191,pml55,pmk50,'','' ",            #ruc23 ~ ruc34
             " FROM ",cl_get_target_table(g_plant_new,'pml_file'),
             "     ,",cl_get_target_table(g_plant_new,'pmk_file'),
             " WHERE pml01='",p_pmk.pmk01,"' AND pmk01 = pml01 ",
             " AND pml02='",p_oeb03,"'",
             " ORDER BY pml02 "
  #FUN-CC0082 Mark&Add End -----
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE t420_prepsel FROM g_sql
   DECLARE t420_curssel CURSOR FOR t420_prepsel 
   FOREACH t420_curssel INTO l_ruc.*
      IF SQLCA.sqlcode THEN
         LET g_msg = g_plant_new,"/",g_fno
         CALL s_errmsg('azw01,oea94',g_msg,' pmk_transfer(FOREACH t420_curssel):',SQLCA.sqlcode,1)
         LET g_errno = SQLCA.sqlcode
         LET g_success = 'N'
         ROLLBACK WORK
         LET g_msg1=' '||' '||g_plant_new||g_fno1
         CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
         LET g_msg=g_msg[1,255]
         CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
         LET g_errno=''
         LET g_msg=''
         LET g_msg1=''
         RETURN
      END IF
      SELECT ima25 INTO l_ruc.ruc13 FROM ima_file WHERE ima01=l_ruc.ruc04
      IF SQLCA.sqlcode=100 THEN LET l_ruc.ruc13=NULL END IF
      CALL s_umfchk(l_ruc.ruc04,l_ruc.ruc16,l_ruc.ruc13)
         RETURNING l_flag,l_rate
      IF l_flag='0' THEN
         LET l_ruc.ruc17=l_rate
      END IF
      LET l_ruc.ruc00='1'
      LET l_ruc.ruc01=p_pmk.pmkplant
      LET l_ruc.ruc05=g_today
      LET l_ruc.ruc06=p_pmk.pmk47
      IF cl_null(l_ruc.ruc06) THEN
         LET l_ruc.ruc06 = p_pmk.pmkplant
         LET l_ruc.ruc29 = 'Y' 
      ELSE
         LET l_ruc.ruc29 = 'N' 
      END IF
      SELECT rty04 INTO l_ruc.ruc26 FROM rty_file
       WHERE rty01=l_ruc.ruc06 AND rty02=l_ruc.ruc04
      LET l_ruc.ruc07=p_pmk.pmk46
      IF p_pmk.pmk46='1' THEN
         LET l_ruc.ruc08=p_pmk.pmk01
         LET l_ruc.ruc09=l_ruc.ruc03
      END IF
      LET l_ruc.ruc19='0'
      LET l_ruc.ruc20='0'
      LET l_ruc.ruc21='0'
      LET l_ruc.ruc22=NULL
      LET l_ruc.ruc33 = ' ' #生产类型1.MPS 2.组合    #FUN-CC0082 Add
      IF l_ruc.ruc12='2' OR l_ruc.ruc12='3' OR l_ruc.ruc12 ='4' THEN  
         INSERT INTO ruc_file VALUES(l_ruc.*) 
         IF STATUS THEN                                                                                                       
            LET g_msg = g_plant_new,"/",g_fno,"/",l_ruc.ruc01
            CALL s_errmsg('azw01,oea94,ruc01',g_msg,' pmk_transfer(ins ruc_file):',SQLCA.sqlcode,1)
            LET g_errno = SQLCA.sqlcode
            LET g_success = 'N'
            ROLLBACK WORK
            LET g_msg1=' '||' '||g_plant_new||g_fno1
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF
      END IF
      IF NOT cl_null(l_ruc.ruc23) AND l_ruc.ruc23<>p_plant THEN 
       LET g_sql =" UPDATE ",cl_get_target_table(g_plant_new,'pml_file'), 
                  " SET pml11='Y' WHERE pml01='",l_ruc.ruc02,"' AND pml02='",l_ruc.ruc03,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
       PREPARE upd_pml11_pre FROM g_sql
       EXECUTE upd_pml11_pre 
         IF STATUS THEN                                                                                                             
            LET g_msg = g_plant_new,"/",g_fno,"/",l_ruc.ruc02,"/",l_ruc.ruc03
            CALL s_errmsg('azw01,oea94,pml01,pml02',g_msg,' pmk_transfer(upd pml_file):',SQLCA.sqlcode,1)
            LET g_errno = SQLCA.sqlcode
            LET g_success = 'N'
            ROLLBACK WORK
            LET g_msg1=' '||' '||g_plant_new||g_fno1
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
            CALL p200_log(g_trans_no,g_plant_new,g_fno1,'01','td_sale',g_errno,g_msg,'0','N',g_msg1)
            LET g_errno=''
            LET g_msg=''
            LET g_msg1=''
            RETURN
         END IF    
      END IF 
      INITIALIZE l_ruc.* TO NULL 
   END FOREACH                             
END FUNCTION

#FUN-C50090
