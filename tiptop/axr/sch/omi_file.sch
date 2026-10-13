/*
================================================================================
檔案代號:omi_file
檔案名稱:账龄及备抵呆账计提率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table omi_file
(
omi01       varchar2(4) NOT NULL,    /*帐龄类型                               */
                                     /*帳齡類別                               */
omi11       number(5),               /*第 1 段帐龄天数                        */
                                     /*第 1 段帳齡天數                        */
omi12       number(5),               /*第 2 段帐龄天数                        */
                                     /*第 2 段帳齡天數                        */
omi13       number(5),               /*第 3 段帐龄天数                        */
                                     /*第 3 段帳齡天數                        */
omi14       number(5),               /*第 4 段帐龄天数                        */
                                     /*第 4 段帳齡天數                        */
omi15       number(5),               /*第 5 段帐龄天数                        */
                                     /*第 5 段帳齡天數                        */
omi16       number(5),               /*第 6 段帐龄天数                        */
                                     /*第 6 段帳齡天數                        */
omi21       number(9,4),             /*第 1 段帐龄呆帐计提率                  */
                                     /*第 1 段帳齡呆帳提列率                  */
omi22       number(9,4),             /*第 2 段帐龄呆帐计提率                  */
                                     /*第 2 段帳齡呆帳提列率                  */
omi23       number(9,4),             /*第 3 段帐龄呆帐计提率                  */
                                     /*第 3 段帳齡呆帳提列率                  */
omi24       number(9,4),             /*第 4 段帐龄呆帐计提率                  */
                                     /*第 4 段帳齡呆帳提列率                  */
omi25       number(9,4),             /*第 5 段帐龄呆帐计提率                  */
                                     /*第 5 段帳齡呆帳提列率                  */
omi26       number(9,4)              /*第 6 段帐龄呆帐计提率                  */
                                     /*第 6 段帳齡呆帳提列率                  */
);

alter table omi_file add  constraint omi_pk primary key  (omi01) enable validate;
grant select on omi_file to tiptopgp;
grant update on omi_file to tiptopgp;
grant delete on omi_file to tiptopgp;
grant insert on omi_file to tiptopgp;
grant index on omi_file to public;
grant select on omi_file to ods;
