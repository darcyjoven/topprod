# Prog. Version..: '5.30.06-13.03.12(00000)'     #
DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_status(p_status)
  DEFINE p_status VARCHAR(1)
  DEFINE l_str    VARCHAR(4)
  CASE g_lang
       WHEN '0'
          CASE WHEN p_status='0' LET l_str=''
               WHEN p_status='1' LET l_str='OPEN'
               WHEN p_status='2' LET l_str='託收'
               WHEN p_status='3' LET l_str='質押'
               WHEN p_status='4' LET l_str='票貼'
               WHEN p_status='5' LET l_str='轉付'
               WHEN p_status='6' LET l_str='撤票'
               WHEN p_status='7' LET l_str='退票'
               WHEN p_status='8' LET l_str='兌現'
          END CASE
       WHEN '2'
          CASE WHEN p_status='0' LET l_str=''
               WHEN p_status='1' LET l_str='OPEN'
               WHEN p_status='2' LET l_str='託收'
               WHEN p_status='3' LET l_str='質押'
               WHEN p_status='4' LET l_str='票貼'
               WHEN p_status='5' LET l_str='轉付'
               WHEN p_status='6' LET l_str='撤票'
               WHEN p_status='7' LET l_str='退票'
               WHEN p_status='8' LET l_str='兌現'
          END CASE
       OTHERWISE
          CASE WHEN p_status='0' LET l_str=''
               WHEN p_status='1' LET l_str='OPEN'
               WHEN p_status='2' LET l_str='託收'
               WHEN p_status='3' LET l_str='質押'
               WHEN p_status='4' LET l_str='票貼'
               WHEN p_status='5' LET l_str='轉付'
               WHEN p_status='6' LET l_str='撤票'
               WHEN p_status='7' LET l_str='退票'
               WHEN p_status='8' LET l_str='兌現'
          END CASE
  END CASE
  RETURN l_str
END FUNCTION
