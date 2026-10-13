/*
================================================================================
檔案代號:hrby_file
檔案名稱:刷卡记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrby_file
(
hrby01      varchar2(20) NOT NULL,   /*单据编号                               */
hrby02      number(5) NOT NULL,      /*项次                                   */
hrby03      varchar2(50),            /*刷卡机号                               */
hrby04      varchar2(50),            /*卡号                                   */
hrby05      date,                    /*日期                                   */
hrby06      varchar2(8),             /*时间                                   */
hrby07      varchar2(50),            /*功能键                                 */
hrby08      varchar2(255),           /*备注                                   */
hrby09      varchar2(50),            /*刷卡人                                 */
hrby10      varchar2(255),           /*刷卡用途                               */
hrby11      varchar2(1) NOT NULL,    /*采集结果                               */
hrbyud01    varchar2(255),
hrbyud02    varchar2(40),
hrbyud03    varchar2(40),
hrbyud04    varchar2(40),
hrbyud05    varchar2(40),
hrbyud06    varchar2(40),
hrbyud07    number(15,3),
hrbyud08    number(15,3),
hrbyud09    number(15,3),
hrbyud10    number(10),
hrbyud11    number(10),
hrbyud12    number(10),
hrbyud13    date,
hrbyud14    date,
hrbyud15    date,
hrby12      varchar2(1) NOT NULL,    /*类型                                   */
                                     /*'1':数据采集; '2':补刷卡               */
hrby13      varchar2(10),            /*补刷卡原因                             */
hrbyacti    varchar2(1)              /*资料有效否                             */
);

alter table hrby_file add  constraint hrby_pk primary key  (hrby01,hrby02,hrby12) enable validate;
grant select on hrby_file to tiptopgp;
grant update on hrby_file to tiptopgp;
grant delete on hrby_file to tiptopgp;
grant insert on hrby_file to tiptopgp;
grant index on hrby_file to public;
grant select on hrby_file to ods;
