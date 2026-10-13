/*
================================================================================
檔案代號:tqu_file
檔案名稱:合同物返条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqu_file
(
tqu01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
tqu02       varchar2(1) DEFAULT ' ' NOT NULL, /*物返类型 1-单次返,2-累计返*/
tqu03       date DEFAULT sysdate NOT NULL, /*起始日期,适用此物返条件的开*/
tqu04       date DEFAULT sysdate NOT NULL, /*截止日期,适用此物返条件的截*/
tqu05       varchar2(1),             /*累计区间 1-月,2-季,3-年,4-依起         */
tqu06       varchar2(40) DEFAULT ' ' NOT NULL, /*销售品号*/
tqu07       varchar2(1),             /*物返依据 1-依销售数量,2-依销           */
tqu08       number(20,6) DEFAULT '0' NOT NULL, /*起始数*/
tqu09       number(20,6) DEFAULT '0' NOT NULL, /*截止数*/
tqu10       varchar2(4),             /*销售单位                               */
tqu11       varchar2(40),            /*物返品号                               */
tqu12       number(15,3),            /*物返数                                 */
tqu13       varchar2(4),             /*物返单位                               */
tqu14       number(5) DEFAULT '0' NOT NULL, /*项次*/
tqu15       varchar2(10),            /*理由码                                 */
tquplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqulegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tqu_file add  constraint tqu_pk primary key  (tqu01,tqu02,tqu03,tqu04,tqu06,tqu08,tqu09) enable validate;
grant select on tqu_file to tiptopgp;
grant update on tqu_file to tiptopgp;
grant delete on tqu_file to tiptopgp;
grant insert on tqu_file to tiptopgp;
grant index on tqu_file to public;
grant select on tqu_file to ods;
