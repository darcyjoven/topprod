/*
================================================================================
檔案代號:aag_file
檔案名稱:会计科目名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table aag_file
(
aag01       varchar2(24) NOT NULL,   /*科目编号                               */
aag02       varchar2(255),           /*科目名称                               */
aag03       varchar2(1),             /*科目性质                               */
aag04       varchar2(1),             /*资产损益别                             */
aag05       varchar2(1),             /*本科目是否作部门明细管理               */
aag06       varchar2(1),             /*正常余额类型                           */
aag07       varchar2(1),             /*统制明细别                             */
aag08       varchar2(24),            /*所属统制帐户科目                       */
aag09       varchar2(1),             /*是否为货币性科目                       */
aag10       varchar2(10),            /*No Use                                 */
aag11       varchar2(4),             /*No Use                                 */
aag12       varchar2(4),             /*计数单位                               */
aag13       varchar2(255),           /*额外名称                               */
aag14       varchar2(255),           /*备注                                   */
aag15       varchar2(10),            /*核算项-1类型编号                       */
aag16       varchar2(10),            /*核算项-2类型编号                       */
aag17       varchar2(10),            /*核算项-3类型编号                       */
aag18       varchar2(10),            /*核算项-4类型编号                       */
aag151      varchar2(1),             /*核算项-1控制方式                       */
aag161      varchar2(1),             /*核算项-2控制方式                       */
aag171      varchar2(1),             /*核算项-3控制方式                       */
aag181      varchar2(1),             /*核算项-4控制方式                       */
aag19       number(5),               /*财务比率分析类型                       */
aag20       varchar2(1),             /*细项立冲否                             */
aag21       varchar2(1),             /*线上预算控制                           */
aag221      varchar2(5),             /*费用固定变动别                         */
aag222      varchar2(5),             /*凭证项次异动别                         */
aag223      varchar2(10),            /*分类码一                               */
aag224      varchar2(10),            /*分类码二                               */
aag225      varchar2(10),            /*分类码三                               */
aag226      varchar2(10),            /*分类码四                               */
aag23       varchar2(1),             /*作项目管理                             */
aag24       number(5),               /*科目层级                               */
aag25       varchar2(1),             /*No Use                                 */
aag26       varchar2(1),             /*No Use                                 */
aagacti     varchar2(1),             /*资料有效码                             */
aaguser     varchar2(10),            /*资料所有者                             */
aaggrup     varchar2(10),            /*资料所有群                             */
aagmodu     varchar2(10),            /*资料更改者                             */
aagdate     date,                    /*最近更改日                             */
aag31       varchar2(10),            /*核算项-5类型编号                       */
                                     /*#FUN-5C0015                            */
aag311      varchar2(1),             /*核算项-5录入控制                       */
                                     /*#FUN-5C0015                            */
aag32       varchar2(10),            /*核算项-6类型编号                       */
                                     /*#FUN-5C0015                            */
aag321      varchar2(1),             /*核算项-6录入控制                       */
                                     /*#FUN-5C0015                            */
aag33       varchar2(10),            /*核算项-7类型编号                       */
                                     /*#FUN-5C0015                            */
aag331      varchar2(1),             /*核算项-7录入控制                       */
                                     /*#FUN-5C0015                            */
aag34       varchar2(10),            /*核算项-8类型编号                       */
                                     /*#FUN-5C0015                            */
aag341      varchar2(1),             /*核算项-8录入控制                       */
                                     /*#FUN-5C0015                            */
aag35       varchar2(10),            /*核算项-9类型编号                       */
                                     /*#FUN-5C0015                            */
aag351      varchar2(1),             /*核算项-9录入控制                       */
                                     /*#FUN-5C0015                            */
aag36       varchar2(10),            /*核算项-10类型编号                      */
                                     /*#FUN-5C0015                            */
aag361      varchar2(1),             /*核算项-10录入控制                      */
                                     /*#FUN-5C0015                            */
aag37       varchar2(10),            /*关系人异动码类型编号                   */
                                     /*#FUN-5C0015                            */
aag371      varchar2(1),             /*关系人异动码录入控制                   */
                                     /*#FUN-5C0015                            */
aag38       varchar2(1),             /*是否为内部管理科目                     */
aag00       varchar2(5) NOT NULL,    /*帐套                                   */
aag39       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
aag40       number(10),              /*抛转次数                               */
aagoriu     varchar2(10),            /*资料建立者                             */
aagorig     varchar2(10),            /*资料建立部门                           */
aag41       varchar2(6),             /*现金变动码                             */
aag42       varchar2(1) DEFAULT 'N' NOT NULL, /*按余额类型产生分录*/
aag43       varchar2(1),             /*客商管理                               */
aag44       varchar2(1) DEFAULT ' ' NOT NULL /*控制核算作业*/
);

create        index aag_02 on aag_file (aag08);
alter table aag_file add  constraint aag_pk primary key  (aag00,aag01) enable validate;
grant select on aag_file to tiptopgp;
grant update on aag_file to tiptopgp;
grant delete on aag_file to tiptopgp;
grant insert on aag_file to tiptopgp;
grant index on aag_file to public;
grant select on aag_file to ods;
