# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Date & Author..: #FUN-AC0060 10/12/31 By Mandy
#---------------------------------------------------------------------------------------------
# Modify.........: #FUN-AC0060 11/07/05 By Mandy PLM GP5.1追版至GP5.25 以上為GP5.1單號
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE   g_cnt        LIKE type_file.num10     
DEFINE   g_level      LIKE type_file.num5      
DEFINE   g_msg        LIKE ze_file.ze03        
DEFINE   g_status     LIKE type_file.num5      
DEFINE   sr1          DYNAMIC ARRAY OF LIKE bmb_file.bmb03    
DEFINE   sr2          DYNAMIC ARRAY OF LIKE bmb_file.bmb03    
DEFINE   l_ac,l_i     LIKE type_file.num5                     

FUNCTION s_decl_bmb_m(p_dbs_sep)
DEFINE   l_sql        LIKE type_file.chr1000   
DEFINE   p_dbs_sep    LIKE type_file.chr50

    LET l_sql="SELECT bmb03 FROM ",p_dbs_sep CLIPPED,"bmb_file,",p_dbs_sep CLIPPED,"bma_file",  
              " WHERE bmb01 = ?",
              "   AND bmb01 = bma01 ",  
              "   AND bmaacti = 'Y' ", 
              " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ", 
              " AND (bmb05 >'",g_today, "' OR bmb05 IS NULL) "
    LET l_sql = l_sql CLIPPED

    PREPARE bmb03_m_pre FROM l_sql
    DECLARE bmb03_m_cur CURSOR WITH HOLD FOR bmb03_m_pre
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg=g_today,"/",g_today
          CALL s_errmsg("bmb04,bmb05",g_showmsg,"decl bmb03_m_cur",STATUS,0)
       ELSE
          CALL cl_err('decl bmb03_m_cur',STATUS,1) #加強show訊息
       END IF
    END IF

    LET l_sql="SELECT bmb01 FROM ",p_dbs_sep CLIPPED,"bmb_file,",p_dbs_sep CLIPPED,"bma_file",
              " WHERE bmb03 = ? ",
              "   AND bmb01 = bma01 ",  
              "   AND bmaacti = 'Y' ",  
              "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ", 
              "   AND (bmb05 >'",g_today, "' OR bmb05 IS NULL) "
    PREPARE bmb01_m_pre FROM l_sql
    DECLARE bmb01_m_cur CURSOR WITH HOLD FOR bmb01_m_pre
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg=g_today,"/",g_today
          CALL s_errmsg("bmb04,bmb05",g_showmsg,"decl bmb01_m_cur",STATUS,0)
       ELSE
          CALL cl_err('decl bmb01_m_cur',STATUS,1) #加強show訊息
       END IF
    END IF
END FUNCTION

FUNCTION s_uima146_m(p_bma01,p_dbs_sep)
DEFINE p_bma01   LIKE bma_file.bma01
DEFINE p_dbs_sep    LIKE type_file.chr50
DEFINE l_bmb03   LIKE bmb_file.bmb03
DEFINE l_str     STRING                                 
DEFINE l_sql     STRING

   IF g_success='N' THEN RETURN END IF
   LET l_sql = "UPDATE ",p_dbs_sep CLIPPED,"ima_file",
               " SET ima146 = 'Y' ",
               " WHERE ima01 = '",p_bma01,"'"
   PREPARE upd_ima146_p1 FROM l_sql
   EXECUTE upd_ima146_p1
   IF STATUS OR sqlca.sqlerrd[3]=0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("ima01",p_bma01,"","mfg6063",1)
      ELSE
         CALL cl_err3("upd","ima_file",p_bma01,"",'mfg6063',"","",1)   
      END IF
      LET g_success='N'
      RETURN
   END IF
   LET g_level=0
   CALL get_mai_bom_m(p_bma01,'u',g_level,p_dbs_sep)    #No.FUN-B80100---修改get_main_bom_m為get_mai_bom_m--- 

   LET l_sql = "SELECT COUNT(*) FROM ",p_dbs_sep CLIPPED,"bmb_file",
               " WHERE bmb01 = '",p_bma01,"'",
               "   AND (bmb04 <= '",g_today,"'"," OR bmb04 IS NULL) ",
               "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL) "
   PREPARE sel_ima146_p1 FROM l_sql
   EXECUTE sel_ima146_p1 INTO g_cnt
   IF g_cnt=0 THEN RETURN END IF

   LET l_ac=1
   #抓下階
   FOREACH bmb03_m_cur 
   USING p_bma01
   INTO sr1[l_ac]
      LET l_str = p_bma01,' -> ',sr1[l_ac]
      CALL cl_msg(l_str)
      
      LET l_str = 'LLC check lower level item no->',p_bma01,' -> ',sr1[l_ac],'->',l_ac
      CALL cl_msg(l_str)
      CALL ui.Interface.refresh()
      LET l_ac=l_ac+1

   END FOREACH
   IF STATUS
    THEN 
        IF g_bgerr THEN
           CALL s_errmsg("","","foreach bmb03_m_cur",STATUS,1)
        ELSE
           CALL cl_err('foreach bmb03_m_cur',STATUS,1) #MOD-530319 加強show訊息
        END IF
        LET g_success='N'
        RETURN
   END IF
   LET l_ac=l_ac-1
   IF l_ac>0 THEN
      FOR l_i=1 TO l_ac
          CALL s_uima146_m(sr1[l_i],p_dbs_sep)
      END FOR
   END IF
   RETURN
END FUNCTION

## 尋找該料件所存在之主件(成品)
FUNCTION get_mai_bom_m(p_bmb03,p_cmd,p_level,p_dbs_sep)      #No.FUN-B80100---修改get_main_bom_m為get_mai_bom_m---
DEFINE p_bmb03   LIKE bmb_file.bmb03
DEFINE p_cmd     LIKE type_file.chr1      
DEFINE p_level   LIKE type_file.num5      
DEFINE p_dbs_sep LIKE type_file.chr50
DEFINE l_prog    LIKE type_file.chr20     
DEFINE l_bmb01   LIKE bmb_file.bmb01
DEFINE l_str     STRING                            
DEFINE l_sql     STRING                            

  #Debug用的
  #LET g_msg='目前是第',p_level ,'階',' 元件',p_bmb03 CLIPPED,'要去抓上階'
  #CALL cl_err(g_msg,'!',1)

   IF g_status>0 OR g_success='N' THEN RETURN END IF
   IF cl_null(p_bmb03) THEN RETURN END IF
   LET l_ac=1
   #抓上階
   FOREACH bmb01_m_cur 
   USING p_bmb03
   INTO sr2[l_ac]
      LET l_str = p_bmb03,' <- ',sr2[l_ac]
      CALL cl_msg(l_str) 
      LET l_str = 'LLC check upper level item no->',p_bmb03,' -> ',sr2[l_ac],'->',l_ac
      CALL cl_msg(l_str)
      CALL ui.Interface.refresh()
      LET l_ac=l_ac+1
      #--
   END FOREACH
   IF STATUS
    THEN 
        IF g_bgerr THEN
           CALL s_errmsg("","","foreach bmb01_m_cur",STATUS,1)
        ELSE
           CALL cl_err('foreach bmb01_m_cur',STATUS,1)#MOD-530319 加強show訊息
        END IF
        LET g_success='N'
   END IF
   LET l_ac=l_ac-1
   LET p_level = p_level + 1  
   IF l_ac>0 THEN
      LET g_level = g_level+1 
      IF p_level > 20  THEN 
          IF g_bgerr THEN
             CALL s_errmsg("str06",20,"","mfg2644",1)
          ELSE
             CALL cl_err(p_bmb03,'mfg2644',1) 
          END IF
          LET g_success='N' 
      END IF 
      IF p_cmd='u'   # verify BOM
      THEN 
           LET l_sql = "UPDATE ",p_dbs_sep CLIPPED,"ima_file",
                       "   SET ima146 = 'Y' ",
                       " WHERE ima01 = '",p_bmb03,"'"
           PREPARE upd_ima146_p2 FROM l_sql
           EXECUTE upd_ima146_p2

           IF STATUS OR sqlca.sqlerrd[3]=0
            THEN 
            IF g_bgerr THEN
               CALL s_errmsg("ima01",p_bmb03,"","mfg6063",1)
            ELSE
               CALL cl_err3("upd","ima_file",p_bmb03,"","mfg6063","","",1)  #加強show訊息 
            END IF
                LET g_success='N'
           END IF
      END IF
      FOR l_i=1 TO l_ac CALL get_mai_bom_m(sr2[l_i],p_cmd,p_level,p_dbs_sep) END FOR        #No.FUN-B80100---修改get_main_bom_m為get_mai_bom_m--- 
   ELSE
      LET g_level=g_level-1
      IF p_cmd='c' THEN  # verify BOM
          LET g_msg=cl_getmsg('abm-001',g_lang)
          LET l_str = p_bmb03,': ',g_msg CLIPPED
          CALL cl_msg(l_str)
          #只有abmi600有CALL get_mai_bom_m(g_bma.bma01,'c',1,p_dbs_sep)                     #No.FUN-B80100---修改get_main_bom_m為get_mai_bom_m--- 
          LET l_prog = g_prog  #TQC-680054 add
          IF p610(p_bmb03,'abmi600')>0 THEN LET g_success = 'N' END IF 
          LET g_prog = l_prog  #TQC-680054 add
      ELSE   # p_cmd='u'
         LET l_sql = "UPDATE ",p_dbs_sep CLIPPED,"ima_file",
                     "   SET ima146 = '0' ",
                     " WHERE ima01 = '",p_bmb03,"'"
         PREPARE upd_ima146_p3 FROM l_sql
         EXECUTE upd_ima146_p3
         IF STATUS OR sqlca.sqlerrd[3]=0
          THEN 
          IF g_bgerr THEN
             CALL s_errmsg("ima01",p_bmb03,"","mfg6063",1)
          ELSE
             CALL cl_err3("upd","ima_file",p_bmb03,"","mfg6063","","",1)  
          END IF
              LET g_success='N'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-AC0060
