/*
================================================================================
檔案代號:aec_file
檔案名稱:核算项分类账档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aec_file
(
aec00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aec01       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aec02       date DEFAULT sysdate NOT NULL, /*凭证日期*/
aec03       varchar2(20) DEFAULT ' ' NOT NULL, /*凭证编号*/
aec04       number(5) DEFAULT '0' NOT NULL, /*项次*/
aec05       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项*/
aec051      varchar2(2) DEFAULT ' ' NOT NULL, /*核算项顺序*/
aec052      varchar2(10) DEFAULT ' ' NOT NULL, /*核算项类型编号*/
                                     /*#FUN-5C0015                            */
aeclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index aec_01 on aec_file (aec01,aec05,aec02);
create        index aec_03 on aec_file (aec03,aec04);
create        index aec_02 on aec_file (aec05,aec01,aec02);
alter table aec_file add  constraint aec_pk primary key  (aec00,aec01,aec02,aec03,aec04,aec05,aec051,aec052,aeclegal) enable validate;
grant select on aec_file to tiptopgp;
grant update on aec_file to tiptopgp;
grant delete on aec_file to tiptopgp;
grant insert on aec_file to tiptopgp;
grant index on aec_file to public;
grant select on aec_file to ods;
