/*
================================================================================
檔案代號:abh_file
檔案名稱:凭证项次冲账异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abh_file
(
abh00       varchar2(5) NOT NULL,    /*帐套                                   */
abh01       varchar2(20) NOT NULL,   /*凭证编号                               */
abh02       number(5) NOT NULL,      /*项次                                   */
abh021      date,                    /*凭证日期                               */
abh03       varchar2(24),            /*科目编号                               */
abh04       varchar2(80),            /*摘要                                   */
abh05       varchar2(10),            /*部门                                   */
abh06       number(5) NOT NULL,      /*行序                                   */
abh07       varchar2(20) NOT NULL,   /*立帐凭证编号                           */
abh08       number(5) NOT NULL,      /*项次                                   */
abh09       number(20,6) NOT NULL,   /*冲帐金额                               */
abh11       varchar2(30),            /*核算项-1                               */
abh12       varchar2(30),            /*核算项-2                               */
abh13       varchar2(30),            /*核算项-3                               */
abh14       varchar2(30),            /*核算项-4                               */
abh15       varchar2(1),             /*No Use                                 */
abh16       varchar2(1),             /*No Use                                 */
abh17       varchar2(1),             /*No Use                                 */
abhconf     varchar2(1),             /*确认码                                 */
abh31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
abh32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
abh33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
abh34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
abh35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
abh36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
abh37       varchar2(30),            /*No Use                                 */
abhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index abh_02 on abh_file (abh03);
alter table abh_file add  constraint abh_pk primary key  (abh01,abh02,abh00,abh06,abh07,abh08) enable validate;
grant select on abh_file to tiptopgp;
grant update on abh_file to tiptopgp;
grant delete on abh_file to tiptopgp;
grant insert on abh_file to tiptopgp;
grant index on abh_file to public;
grant select on abh_file to ods;
