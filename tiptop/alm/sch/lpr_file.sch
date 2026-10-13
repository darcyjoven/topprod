/*
================================================================================
檔案代號:lpr_file
檔案名稱:换物设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpr_file
(
lpr01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lpr02       number(20) DEFAULT '0' NOT NULL, /*积分达*/
lpr03       varchar2(40) DEFAULT ' ' NOT NULL, /*赠品编号*/
lprlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lprplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lprpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
lpr04       varchar2(4),             /*单位                                   */
lpr05       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
lpr06       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpr07       number(20,6) DEFAULT '0' NOT NULL, /*累计消费额*/
lpr08       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lpr00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换物, 1.累计消费额换物           */
lpr09       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lpr_file add  constraint lpr_pk primary key  (lpr00,lpr01,lpr06,lpr08,lpr09,lprplant) enable validate;
grant select on lpr_file to tiptopgp;
grant update on lpr_file to tiptopgp;
grant delete on lpr_file to tiptopgp;
grant insert on lpr_file to tiptopgp;
grant index on lpr_file to public;
grant select on lpr_file to ods;
