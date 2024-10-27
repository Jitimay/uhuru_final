// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupModelCollection on Isar {
  IsarCollection<GroupModel> get groupModels => this.collection();
}

const GroupModelSchema = CollectionSchema(
  name: r'GroupModel',
  id: 6533975783226463878,
  properties: {
    r'createDate': PropertySchema(
      id: 0,
      name: r'createDate',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 1,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'hasExited': PropertySchema(
      id: 2,
      name: r'hasExited',
      type: IsarType.bool,
    ),
    r'isAtive': PropertySchema(
      id: 3,
      name: r'isAtive',
      type: IsarType.bool,
    ),
    r'lastActivity': PropertySchema(
      id: 4,
      name: r'lastActivity',
      type: IsarType.string,
    ),
    r'lastMessage': PropertySchema(
      id: 5,
      name: r'lastMessage',
      type: IsarType.string,
    ),
    r'lastSenderName': PropertySchema(
      id: 6,
      name: r'lastSenderName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 8,
      name: r'picture',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 9,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'unread': PropertySchema(
      id: 10,
      name: r'unread',
      type: IsarType.long,
    ),
    r'wasRemoved': PropertySchema(
      id: 11,
      name: r'wasRemoved',
      type: IsarType.bool,
    )
  },
  estimateSize: _groupModelEstimateSize,
  serialize: _groupModelSerialize,
  deserialize: _groupModelDeserialize,
  deserializeProp: _groupModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _groupModelGetId,
  getLinks: _groupModelGetLinks,
  attach: _groupModelAttach,
  version: '3.1.0+1',
);

int _groupModelEstimateSize(
  GroupModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createDate.length * 3;
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lastActivity.length * 3;
  bytesCount += 3 + object.lastMessage.length * 3;
  {
    final value = object.lastSenderName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.picture.length * 3;
  bytesCount += 3 + object.remoteId.length * 3;
  return bytesCount;
}

void _groupModelSerialize(
  GroupModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.createDate);
  writer.writeString(offsets[1], object.groupId);
  writer.writeBool(offsets[2], object.hasExited);
  writer.writeBool(offsets[3], object.isAtive);
  writer.writeString(offsets[4], object.lastActivity);
  writer.writeString(offsets[5], object.lastMessage);
  writer.writeString(offsets[6], object.lastSenderName);
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.picture);
  writer.writeString(offsets[9], object.remoteId);
  writer.writeLong(offsets[10], object.unread);
  writer.writeBool(offsets[11], object.wasRemoved);
}

GroupModel _groupModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupModel(
    createDate: reader.readString(offsets[0]),
    groupId: reader.readStringOrNull(offsets[1]),
    hasExited: reader.readBoolOrNull(offsets[2]) ?? false,
    id: id,
    isAtive: reader.readBoolOrNull(offsets[3]) ?? true,
    lastActivity: reader.readString(offsets[4]),
    lastMessage: reader.readStringOrNull(offsets[5]) ?? '',
    lastSenderName: reader.readStringOrNull(offsets[6]),
    name: reader.readString(offsets[7]),
    picture: reader.readString(offsets[8]),
    remoteId: reader.readString(offsets[9]),
    unread: reader.readLongOrNull(offsets[10]) ?? 0,
    wasRemoved: reader.readBoolOrNull(offsets[11]) ?? false,
  );
  return object;
}

P _groupModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _groupModelGetId(GroupModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _groupModelGetLinks(GroupModel object) {
  return [];
}

void _groupModelAttach(IsarCollection<dynamic> col, Id id, GroupModel object) {
  object.id = id;
}

extension GroupModelQueryWhereSort
    on QueryBuilder<GroupModel, GroupModel, QWhere> {
  QueryBuilder<GroupModel, GroupModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupModelQueryWhere
    on QueryBuilder<GroupModel, GroupModel, QWhereClause> {
  QueryBuilder<GroupModel, GroupModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GroupModelQueryFilter
    on QueryBuilder<GroupModel, GroupModel, QFilterCondition> {
  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> createDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> createDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> createDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createDate',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      createDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createDate',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      groupIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> hasExitedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasExited',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> isAtiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAtive',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActivity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastActivity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastActivity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActivity',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastActivityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastActivity',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSenderName',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSenderName',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSenderName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastSenderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSenderName',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      lastSenderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastSenderName',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      pictureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'picture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> remoteIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> unreadEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> unreadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> unreadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> unreadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unread',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterFilterCondition> wasRemovedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasRemoved',
        value: value,
      ));
    });
  }
}

extension GroupModelQueryObject
    on QueryBuilder<GroupModel, GroupModel, QFilterCondition> {}

extension GroupModelQueryLinks
    on QueryBuilder<GroupModel, GroupModel, QFilterCondition> {}

extension GroupModelQuerySortBy
    on QueryBuilder<GroupModel, GroupModel, QSortBy> {
  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByCreateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByCreateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByHasExited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExited', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByHasExitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExited', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByIsAtive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAtive', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByIsAtiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAtive', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByLastActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByLastActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByLastSenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSenderName', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy>
      sortByLastSenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSenderName', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByWasRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRemoved', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> sortByWasRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRemoved', Sort.desc);
    });
  }
}

extension GroupModelQuerySortThenBy
    on QueryBuilder<GroupModel, GroupModel, QSortThenBy> {
  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByCreateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByCreateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByHasExited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExited', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByHasExitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasExited', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByIsAtive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAtive', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByIsAtiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAtive', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByLastActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByLastActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivity', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByLastSenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSenderName', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy>
      thenByLastSenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSenderName', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByWasRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRemoved', Sort.asc);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QAfterSortBy> thenByWasRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRemoved', Sort.desc);
    });
  }
}

extension GroupModelQueryWhereDistinct
    on QueryBuilder<GroupModel, GroupModel, QDistinct> {
  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByCreateDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByHasExited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasExited');
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByIsAtive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAtive');
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByLastActivity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActivity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByLastMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByLastSenderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSenderName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByRemoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unread');
    });
  }

  QueryBuilder<GroupModel, GroupModel, QDistinct> distinctByWasRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasRemoved');
    });
  }
}

extension GroupModelQueryProperty
    on QueryBuilder<GroupModel, GroupModel, QQueryProperty> {
  QueryBuilder<GroupModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> createDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createDate');
    });
  }

  QueryBuilder<GroupModel, String?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<GroupModel, bool, QQueryOperations> hasExitedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasExited');
    });
  }

  QueryBuilder<GroupModel, bool, QQueryOperations> isAtiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAtive');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> lastActivityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActivity');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> lastMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessage');
    });
  }

  QueryBuilder<GroupModel, String?, QQueryOperations> lastSenderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSenderName');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<GroupModel, String, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<GroupModel, int, QQueryOperations> unreadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unread');
    });
  }

  QueryBuilder<GroupModel, bool, QQueryOperations> wasRemovedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasRemoved');
    });
  }
}
