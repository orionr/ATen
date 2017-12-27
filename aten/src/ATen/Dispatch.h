#pragma once

#include <utility>

namespace at {

// FIXME: nvcc can't seem to do type deduction on
// decltype(F<double>::apply(std::forward<Args>(args)...)) so we have to explicitly pass the return type

template<typename R, template <typename> class F, typename ... Args>
R dispatch_all(const Type& the_type, const char *name, Args&&... args) {
  switch(the_type.scalarType()) {
    case ScalarType::Byte:
      return F<uint8_t>::apply(std::forward<Args>(args)...);
    case ScalarType::Char:
      return F<int8_t>::apply(std::forward<Args>(args)...);
    case ScalarType::Double:
      return F<double>::apply(std::forward<Args>(args)...);
    case ScalarType::Float:
      return F<float>::apply(std::forward<Args>(args)...);
    case ScalarType::Int:
      return F<int>::apply(std::forward<Args>(args)...);
    case ScalarType::Long:
      return F<int64_t>::apply(std::forward<Args>(args)...);
    case ScalarType::Short:
      return F<int16_t>::apply(std::forward<Args>(args)...);
    case ScalarType::Half:
      return F<Half>::apply(std::forward<Args>(args)...);
    default:
      runtime_error("%s not implemented for '%s'", name, the_type.toString());
    }
}

template<typename R, template <typename> class F, typename ... Args>
R dispatch_floating_types(const Type& the_type, const char *name, Args&&... args) {
  switch(the_type.scalarType()) {
    case ScalarType::Double:
      return F<double>::apply(std::forward<Args>(args)...);
    case ScalarType::Float:
      return F<float>::apply(std::forward<Args>(args)...);
    case ScalarType::Half: // no native half math on either CPU or GPU.
    default:
      runtime_error("%s not implemented for '%s'", name, the_type.toString());
  }
}


}
