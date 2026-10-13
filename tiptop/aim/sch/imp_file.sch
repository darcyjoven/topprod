/*
================================================================================
檔案代號:imp_file
檔案名稱:借料资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imp_file
(
imp01       varchar2(20) NOT NULL,   /*借料单号                               */
                                     /*借料單號                               */
imp02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
imp03       varchar2(40),            /*借料料件编号                           */
                                     /*借料料件編號                           */
imp04       number(15,3),            /*借料数量                               */
                                     /*借料數量                               */
imp05       varchar2(4),             /*借料单位                               */
                                     /*借料單位                               */
imp06       date,                    /*预计偿还日期                           */
                                     /*預計償還日期                           */
imp07       varchar2(1),             /*结案否                                 */
                                     /*結案否                                 */
                                     /*Y.已全部償還                           */
                                     /*N.未償還或償還一部份                   */
imp08       number(15,3),            /*已偿还数量                             */
                                     /*已償還數量                             */
                                     /*系統維護                               */
imp09       number(20,6),            /*预计单位成本                           */
                                     /*預計單位成本                           */
imp10       number(20,6),            /*金额                                   */
                                     /*金額=imp04*imp09 No:6817               */
                                     /*金額可由axct305修改                    */
imp11       varchar2(10),            /*仓库编号                               */
                                     /*倉庫代號                               */
imp12       varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
imp13       varchar2(24),            /*存放批号                               */
                                     /*存放批號                               */
imp14       varchar2(4),             /*仓库单位                               */
                                     /*倉庫單位                               */
imp14_fac   number(20,8),            /*借料对仓库单位转换率                   */
                                     /*借料對倉庫單位轉換率                   */
imp20       varchar2(4),             /*单位一                                 */
imp21       number(20,8),            /*单位一转换率(与库存单位)               */
imp22       number(15,3),            /*单位一数量                             */
imp23       varchar2(4),             /*单位二                                 */
imp24       number(20,8),            /*单位二转换率(与库存单位)               */
imp25       number(15,3),            /*单位二数量                             */
imp15       varchar2(1),             /*检验否                                 */
imp930      varchar2(10),            /*成本中心                               */
impplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
implegal    varchar2(10) NOT NULL,   /*所属法人                               */
imp16       varchar2(10)             /*理由码                                 */
);

alter table imp_file add  constraint imp_pk primary key  (imp01,imp02) enable validate;
grant select on imp_file to tiptopgp;
grant update on imp_file to tiptopgp;
grant delete on imp_file to tiptopgp;
grant insert on imp_file to tiptopgp;
grant index on imp_file to public;
grant select on imp_file to ods;
