/*
================================================================================
檔案代號:ozf_file
檔案名稱:ESC平台传回值档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ozf_file
(
ozf01       varchar2(1) NOT NULL,    /*运输模式                               */
ozf02       varchar2(30) NOT NULL,   /*货运代码                               */
ozf03       varchar2(20) NOT NULL,   /*运输业者代码                           */
ozf04       varchar2(30) NOT NULL,   /*起运港                                 */
ozf05       varchar2(30) NOT NULL,   /*卸货港                                 */
ozf06       varchar2(2),             /*状态代码                               */
ozf07       varchar2(255),           /*状态说明                               */
ozf08       varchar2(255),           /*所在地点                               */
ozf09       varchar2(14),            /*状态时间                               */
ozf10       varchar2(255),           /*异常说明                               */
ozf11       varchar2(14),            /*更新时间                               */
ozfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ozflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ozf_file add  constraint ozf_pk primary key  (ozf01,ozf02,ozf03,ozf04,ozf05) enable validate;
grant select on ozf_file to tiptopgp;
grant update on ozf_file to tiptopgp;
grant delete on ozf_file to tiptopgp;
grant insert on ozf_file to tiptopgp;
grant index on ozf_file to public;
grant select on ozf_file to ods;
