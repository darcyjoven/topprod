/*
================================================================================
檔案代號:lst_file
檔案名稱:换券设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lst_file
(
lst01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lst02       varchar2(50),            /*No Use                                 */
lst03       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lst04       date,                    /*起始日期                               */
lst05       date,                    /*终止日期                               */
lst06       varchar2(1) DEFAULT ' ' NOT NULL, /*返券方式*/
lst07       varchar2(1) DEFAULT ' ' NOT NULL, /*签核否*/
lst08       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lst09       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lst10       varchar2(10),            /*审核人                                 */
lst11       date,                    /*审核日期                               */
lst12       varchar2(50),            /*备注                                   */
lstacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lstcrat     date,                    /*资料创建日                             */
lstdate     date,                    /*最近更改日                             */
lstgrup     varchar2(10),            /*资料所有群                             */
lstmodu     varchar2(10),            /*资料更改者                             */
lstuser     varchar2(10),            /*资料所有者                             */
lstoriu     varchar2(10),            /*资料建立者                             */
lstorig     varchar2(10),            /*资料建立部门                           */
lstlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lstplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lstpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lst00       varchar2(1) DEFAULT '1' NOT NULL, /*兑换来源*/
                                     /*0.积分换券，1.累计消费额换券           */
lst13       varchar2(1) DEFAULT '0' NOT NULL, /*累计消费额方式*/
                                     /*0.消费日当天,1.会员累计消费额          */
lst14       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lst15       number(5) DEFAULT '0' NOT NULL, /*版本号*/
lst16       varchar2(1) DEFAULT ' ' NOT NULL, /*发布否*/
lst17       date,                    /*发布日期                               */
lst18       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换限制*/
                                     /*1.不限兑换次数, 2.期间限制兑换次数, 3.一天限制兑换次数*/
lst19       number(5)                /*兑换次数                               */
);

alter table lst_file add  constraint lst_pk primary key  (lst00,lst01,lst03,lst14,lstplant) enable validate;
grant select on lst_file to tiptopgp;
grant update on lst_file to tiptopgp;
grant delete on lst_file to tiptopgp;
grant insert on lst_file to tiptopgp;
grant index on lst_file to public;
grant select on lst_file to ods;
